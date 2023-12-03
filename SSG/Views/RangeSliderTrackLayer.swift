//
//  RangeSliderTrackLayer.swift
//  SSG
//
//  Created by Григорий Стеценко on 01.12.2023.
//

import UIKit
import QuartzCore

class RangeSliderTrackLayer: CALayer {
    
    weak var rangeSlider: RangeSlider?
    
    var valueTextLayer: CATextLayer?
    
    override func draw(in ctx: CGContext) {
        if let slider = rangeSlider {
            // Clip
            let cornerRadius = bounds.height * slider.curvaceousness / 2.0
            let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
            ctx.addPath(path.cgPath)
            
            // Fill the track
            ctx.setFillColor(slider.trackTintColor.cgColor)
            ctx.addPath(path.cgPath)
            ctx.fillPath()
            
            // Fill the highlighted range
            ctx.setFillColor(slider.trackHighlightTintColor.cgColor)
            let lowerValuePosition = CGFloat(slider.positionForValue(value: slider.lowerValue, isLower: true))
            let upperValuePosition = CGFloat(slider.positionForValue(value: slider.upperValue, isLower: false))
            let rect = CGRect(x: lowerValuePosition, y: 0.0, width: upperValuePosition - lowerValuePosition, height: bounds.height)
            ctx.fill(rect)
            
        }
    }
}
