//
//  Extension+UIColor.swift
//  SSG-test
//
//  Created by Григорий Стеценко on 01.12.2023.
//

import UIKit

extension UIColor {
    
    enum AssetsColor: String {
        case mainBlue = "MainBlue"
        case sliderTrackTintColor = "SliderTrackTintColor"
        case sliderTrackHighlightedColor = "SliderTrackHighlightedColor"
        case baseButtonHighlightedBackgroundColor = "BaseButtonHighlightedBackgroundColor"
        case separatorGray = "SeparatorGray"
    }
    
    static func appColor(_ name: AssetsColor) -> UIColor {
        return UIColor(named: name.rawValue) ?? .systemPink
    }
}
