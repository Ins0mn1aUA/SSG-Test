//
//  Extension+UIFont.swift
//  SSG-test
//
//  Created by Григорий Стеценко on 01.12.2023.
//

import UIKit

extension UIFont {
    enum Style: String {
        case medium = "Medium"
    }
    
    static func roboto(style: Style, size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-\(style.rawValue)", size: size)!
    }
}
