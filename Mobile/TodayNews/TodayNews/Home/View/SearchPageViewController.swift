//
//  SearchPageViewController.swift
//  TodayNews
//
//  Created by herongjin on 2022/4/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import Contacts

class SearchPageViewController: TNBaseViewController, UITextFieldDelegate, UITableViewDelegate {
    
    var placeholder = ""
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = SearchViewModel()
    
    @IBAction func goBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.placeholder = placeholder
        textField.delegate = self
        tableView.register(UINib(nibName: "PersonTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        textField.rx.text.orEmpty
            .bind(to: viewModel.searchOB).disposed(by: disposeBag)
        
        viewModel.searchData
            .drive(tableView.rx.items(cellIdentifier: "cell")) { _, model, cell in
                if let cell = cell as? PersonTableViewCell {
                    cell.selectionStyle = .none
                    cell.imgView.image = UIImage(systemName: model.avatar)
                    cell.name.text = model.name
                    cell.phone.text = model.mobile
                }
            }.disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension SearchPageViewController {
    
    class Person {
        var avatar = "person.fill"
        var name: String
        var mobile: String
        
        init(name: String, mobile: String) {
            self.name = name
            self.mobile = mobile
        }
    }
    
    class SearchViewModel {
        //1?????????????????????
        let searchOB = BehaviorSubject(value: "")
        
        let validTypes = [
            //          CNLabelPhoneNumberiPhone,
            CNLabelPhoneNumberMobile,
            //          CNLabelPhoneNumberMain
        ]
        
        lazy var searchData: Driver<[Person]> = {
            return self.searchOB.asObserver()
                .throttle(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)//??????300????????????????????????
                .distinctUntilChanged()//????????????????????????????????????
                .flatMap(requestPerson)
                .asDriver(onErrorJustReturn: [])
        }()
        
        func requestPerson(_ keyword: String) -> Observable<[Person]> {
            if keyword == "?????????" || keyword == "????????????" || keyword == "??????" || keyword == "?????????" {
                return getAllContacts()
            } else if keyword.starts(with: "????????????") {
                let key = keyword.deletingPrefix("????????????")
                return startSearchContactsByName(key)
            } else if keyword.starts(with: "?????????") {
                let key = keyword.deletingPrefix("?????????")
                return startSearchContactsByNumber(key)
            }
            
            return Observable<[Person]>.just([])
        }
        
        // ??????????????????
        func startSearchContactsByName(_ name: String) -> Observable<[Person]> {
            let store = CNContactStore()
            let predicate = CNContact.predicateForContacts(matchingName: name)
            let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
            var persons = [Person]()
            
            do {
                let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
                persons = contacts.map({ contact in
                    return convertCNContactToPerson(contact: contact)
                })
            } catch {
                print("Failed to fetch contact, error: \(error)")
            }
            
            return Observable<[Person]>.just(persons)
        }
        
        // ??????getAllContacts???map
        func startSearchContactsByNumber(_ number: String) -> Observable<[Person]> {
            return getAllContacts()
                .map { persons in
                    return persons.filter{ $0.mobile.contains(number) }
                }
        }
        
        // ?????????????????????
        func getAllContacts() -> Observable<[Person]> {
            let status = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
            if status != .authorized {
                print("????????????")
                return Observable<[Person]>.just([])
            }
            
            let contactStore = CNContactStore()
            let request = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor])
            var persons = [Person]()
            
            do {
                try contactStore.enumerateContacts(with: request) { [weak self] (contact: CNContact, stop) in
                    guard let self = self else { return }
                    persons.append(self.convertCNContactToPerson(contact: contact))
                }
            } catch {
                print(error)
            }
            
            return Observable<[Person]>.just(persons)
        }
        
        // contact must request [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        func convertCNContactToPerson(contact: CNContact) -> Person {
            let fullName = contact.givenName + " " + contact.familyName
            let phoneNums = contact.phoneNumbers
            
            let numbers = phoneNums.compactMap { [weak self] phoneNumber -> String? in
                guard let self = self,
                      let label = phoneNumber.label, self.validTypes.contains(label)
                else { return nil }
                return phoneNumber.value.stringValue
            }
            
            if numbers.isEmpty {
                return Person(name: fullName, mobile: "-")
            } else {
                return Person(name: fullName, mobile: numbers[0])
            }
            
        }
        
        
    }
    
}
