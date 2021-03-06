//
//  SceneDelegate.swift
//  MyCampus
//
//  Created by aicoin on 2022/5/17.
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
        myTabBar.tabBar.tintColor = CPColor.red
        
        if #available(iOS 15.0, *) {
            let barAppearance = UITabBarAppearance()
            barAppearance.configureWithDefaultBackground()
            UITabBar.appearance().scrollEdgeAppearance = barAppearance
            
//            UITableView.appearance().sectionHeaderTopPadding = .leastNonzeroMagnitude
        }
        
        // tabBarItems
        let homePageViewController = RTRootNavigationController(rootViewController: HomePageViewController())
        homePageViewController.tabBarItem = UITabBarItem(title: "首页", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        let personalViewController = RTRootNavigationController(rootViewController: PersonalPageViewController())
        personalViewController.tabBarItem = UITabBarItem(title: "个人", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        // add to tabbar
        myTabBar.viewControllers = [homePageViewController, personalViewController]
        
        myTabBar.selectedIndex = 0
        
        window.rootViewController = myTabBar
        self.window = window
        window.makeKeyAndVisible()
        
        // MARK: 清楚缓存代码
//        try? StoragedMoments.shared.storage?.removeObject(forKey: "MomentsModels")
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

