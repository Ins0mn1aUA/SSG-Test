//
//  AppDelegateRouter.swift
//  SSG-test
//
//  Created by Григорий Стеценко on 01.12.2023.
//

import UIKit

class AppDelegateRouter {
    
    // MARK: - Private properties
    
    private var window: UIWindow?
    
    // MARK: - Init
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    // MARK: - Public methods
    
    public func start() {
//        let newPhotosViewController = NewPhotosViewController()
        let photosViewController = PhotosViewController()
        let navigationController = BaseNavigationViewController(rootViewController: photosViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
}
