////
////  Extension+UIViewController.swift
////  SSG
////
////  Created by Григорий Стеценко on 02.12.2023.
////
//
//import UIKit
//
//extension UIViewController {
//    
//    func setupNavigationBarBackground() {
//        
//        if #available(iOS 15.0, *) {
//            let navigationBarAppearance = UINavigationBar.appearance()
//            var backgroundImage = UIImage(named: "navigationImage")
//            backgroundImage = backgroundImage?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0)
//            navigationBarAppearance.setBackgroundImage(backgroundImage, for: .default)
//            
//            let newNavigationBarAppearance = UINavigationBarAppearance()
//            newNavigationBarAppearance.backgroundImage = backgroundImage
//            navigationBarAppearance.standardAppearance = newNavigationBarAppearance
//            navigationBarAppearance.scrollEdgeAppearance = navigationBarAppearance.standardAppearance
//        } else {
//            navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigationImage"), for: .default)
//        }
//    }
//}
