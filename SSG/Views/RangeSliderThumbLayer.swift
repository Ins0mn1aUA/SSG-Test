//
//  RangeSliderThumbLayer.swift
//  SSG
//
//  Created by Григорий Стеценко on 01.12.2023.
//

import UIKit
import QuartzCore

class RangeSliderThumbLayer: CALayer {
    
    var highlighted: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    weak var rangeSlider: RangeSlider?
    
    override func draw(in ctx: CGContext) {
        if let slider = rangeSlider {
            let thumbPath = UIBezierPath(roundedRect: bounds, cornerRadius: 4)
            ctx.setFillColor(slider.thumbTintColor.cgColor)
            ctx.addPath(thumbPath.cgPath)
            ctx.fillPath()
//            ctx.setFontSize(<#T##size: CGFloat##CGFloat#>)
        }
    }
}
