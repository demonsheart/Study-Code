//
//  SceneDelegate.swift
//  MyTodoList
//
//  Created by aicoin on 2022/5/7.
//

import UIKit
import RTRootNavigationController

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        window.backgroundColor = UIColor.white
        
        // make tabBarController
        let myTabBar = UITabBarController()
        myTabBar.tabBar.tintColor = TDLColor.iconBlue
        
        // fix ios15 bar
        if #available(iOS 15.0, *) {
            let barAppearance = UITabBarAppearance()
            barAppearance.configureWithDefaultBackground()
            barAppearance.backgroundColor = TDLColor.bgGreen
            UITabBar.appearance().scrollEdgeAppearance = barAppearance
        }
        
        // tabBarItems
        let homePageViewController = RTRootNavigationController(rootViewController: HomePageViewController())
        homePageViewController.tabBarItem = UITabBarItem(title: "今天", image: UIImage(systemName: "checklist"), selectedImage: UIImage(systemName: "checklist"))
        
        let monthViewController = RTRootNavigationController(rootViewController: MonthPageViewController())
        monthViewController.tabBarItem = UITabBarItem(title: "月视图", image: UIImage(systemName: "calendar"), selectedImage: UIImage(systemName: "calendar"))
        
        let quadrantPageViewController = RTRootNavigationController(rootViewController: QuadrantsPageViewController())
        quadrantPageViewController.tabBarItem = UITabBarItem(title: "四象限", image: UIImage(systemName: "rectangle.grid.2x2"), selectedImage: UIImage(systemName: "rectangle.grid.2x2"))
        
        let punchPageViewController = RTRootNavigationController(rootViewController: PunchPageViewController())
        punchPageViewController.tabBarItem = UITabBarItem(title: "打卡", image: UIImage(systemName: "clock.badge.checkmark"), selectedImage: UIImage(systemName: "clock.badge.checkmark"))
        
        let personalViewController = RTRootNavigationController(rootViewController: PersonalPageViewController())
        personalViewController.tabBarItem = UITabBarItem(title: "个人", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        
        // add to tabbar
        myTabBar.viewControllers = [homePageViewController, monthViewController, quadrantPageViewController, punchPageViewController, personalViewController]
        
        myTabBar.selectedIndex = 0
        
        window.rootViewController = myTabBar
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

