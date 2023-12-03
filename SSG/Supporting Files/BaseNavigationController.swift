//
//  BaseNavigationController.swift
//  SSG
//
//  Created by Григорий Стеценко on 02.12.2023.
//

import UIKit

class BaseNavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLazyPadView()
    }
    
}

private class BasePadLayout {
    
    static func setup(originalView: UIView) -> UIView {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            originalView.removeFromSuperview()
            originalView.translatesAutoresizingMaskIntoConstraints = false
            
            originalView.layer.cornerRadius = 8
            originalView.layer.masksToBounds = true
            
            let newContainer = UIView()
            newContainer.backgroundColor = UIColor.appColor(.sliderTrackTintColor)
            newContainer.addSubview(originalView)

            NSLayoutConstraint.activate([
                originalView.centerXAnchor.constraint(equalTo: newContainer.centerXAnchor),
                originalView.centerYAnchor.constraint(equalTo: newContainer.centerYAnchor),
                originalView.leadingAnchor.constraint(equalTo: newContainer.leadingAnchor, constant: 80),
                originalView.trailingAnchor.constraint(equalTo: newContainer.trailingAnchor, constant: -80),
                originalView.heightAnchor.constraint(equalTo: newContainer.heightAnchor, constant: -80)
            ])
            
            return newContainer
        }
        
        return originalView
    }
    
}

extension UIViewController {
    
    func configureLazyPadView() {
        view = BasePadLayout.setup(originalView: view)
    }
}
