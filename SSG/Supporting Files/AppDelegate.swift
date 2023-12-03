//
//  AppDelegate.swift
//  SSG-test
//
//  Created by Григорий Стеценко on 01.12.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var appDelegateRouter: AppDelegateRouter?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        setupAppearance()
        appDelegateRouter = AppDelegateRouter(window: window)
        appDelegateRouter?.start()
        
        return true
    }
    
    func setupAppearance() {
        let navigationBarAppearance = UINavigationBar.appearance()

        var backgroundImage = UIImage(named: "navigationImage")
        if UIDevice.current.userInterfaceIdiom == .pad {
            backgroundImage = backgroundImage?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0)
        } else {
            backgroundImage = backgroundImage?.resizableImage(withCapInsets: .zero, resizingMode: .stretch)
        }
        navigationBarAppearance.setBackgroundImage(backgroundImage, for: .default)
        
        let newNavigationBarAppearance = UINavigationBarAppearance()
        newNavigationBarAppearance.backgroundImage = backgroundImage
        navigationBarAppearance.standardAppearance = newNavigationBarAppearance
        navigationBarAppearance.scrollEdgeAppearance = navigationBarAppearance.standardAppearance
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

