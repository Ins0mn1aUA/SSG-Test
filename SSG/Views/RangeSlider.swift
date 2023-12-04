//
//  RangeSlider.swift
//  SSG
//
//  Created by Григорий Стеценко on 01.12.2023.
//

import UIKit
import QuartzCore

class RangeSlider: UIControl {
    
    // MARK: - Public properties
    
    var minimumValue: Double = 18 {
        didSet {
            updateLayerFrames()
        }
    }
    
    var maximumValue: Double = 65 {
        didSet {
            updateLayerFrames()
        }
    }
    
    
    var lowerValue: CGFloat = 18 {
        didSet {
            updateLayerFrames()
        }
    }
    
    
    var upperValue: CGFloat = 65 {
        didSet {
            updateLayerFrames()
        }
    }
    
    var trackHeight: CGFloat = 4 {
        didSet {
            updateLayerFrames()
        }
    }
    
    let trackLayer = RangeSliderTrackLayer()
    let lowerThumbLayer = RangeSliderThumbLayer()
    var lowerThumbTextLayer = UILabel()
    
    let upperThumbLayer = RangeSliderThumbLayer()
    var upperThumbTextLayer = UILabel()
    
    var trackTintColor: UIColor = UIColor.appColor(.sliderTrackTintColor) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    var trackHighlightTintColor: UIColor = UIColor.appColor(.sliderTrackHighlightedColor) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    var thumbTintColor: UIColor = UIColor.appColor(.mainBlue) {
        didSet {
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }

    var curvaceousness: CGFloat = 1.0 {
        didSet {
            trackLayer.setNeedsDisplay()
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }
    
    private var previousLocation = CGPoint()
    
    private var thumbWidth: CGFloat { 32 }
    
    // MARK: - Private properties
    
    public var lowerValueInt: Int { Int((lowerValue).rounded(.down)) }
    public var upperValueInt: Int { Int(upperValue.rounded(.up)) }
    private let error: Double = 0.001
    
    override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    // MARK: - Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Public methods
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousLocation = touch.location(in: self)
        
        // Hit test the thumb layers
        if lowerThumbLayer.frame.contains(previousLocation) {
            lowerThumbLayer.highlighted = true
        } else if upperThumbLayer.frame.contains(previousLocation) {
            upperThumbLayer.highlighted = true
        }
        
        return lowerThumbLayer.highlighted || upperThumbLayer.highlighted
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let oldUpperValueInt = upperValueInt
        let oldLowerValueInt = lowerValueInt
        
        let location = touch.location(in: self)
        
        // 1. Determine by how much the user has dragged
        let deltaLocation = Double(location.x - previousLocation.x)
        
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / Double(bounds.width - thumbWidth)
        
        previousLocation = location
        
        // 2. Update the values
        if lowerThumbLayer.highlighted {
            if lowerValue + deltaValue > minimumValue && lowerValue + deltaValue < upperValue {
                lowerValue += deltaValue
            } else if lowerValue + deltaValue < minimumValue {
                lowerValue = minimumValue
            } else if lowerValue + deltaValue > upperValue {
                lowerValue = upperValue - error
            }
            lowerValue = boundValue(value: lowerValue, toLowerValue: minimumValue, upperValue: upperValue) + (deltaValue < 0 ? error : -error)
        } else if upperThumbLayer.highlighted {
            if upperValue + deltaValue < maximumValue && upperValue + deltaValue > lowerValue {
                upperValue += deltaValue
            } else if upperValue + deltaValue > maximumValue {
                upperValue = maximumValue
            } else if upperValue + deltaValue < lowerValue {
                upperValue = lowerValue + error
            }
            
            upperValue = boundValue(value: upperValue, toLowerValue: lowerValue, upperValue: maximumValue) + (deltaValue < 0 ? error : -error)
        }
        
        // To prevent extra collectionView updates
        if oldUpperValueInt != Int(upperValue.rounded(.up)) || oldLowerValueInt != Int(lowerValue.rounded(.down)) {
            sendActions(for: .valueChanged)            
        }
        
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowerThumbLayer.highlighted = false
        upperThumbLayer.highlighted = false
    }
    
    func updateLayerFrames() {
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        trackLayer.frame = CGRect(origin: CGPoint(x: 0, y: (bounds.height / 2) - trackHeight), size: .init(width: bounds.width, height: trackHeight))
        trackLayer.setNeedsDisplay()
        
        let lowerThumbCenter = CGFloat(positionForValue(value: lowerValue, isLower: true))
        lowerThumbLayer.frame = CGRect(x: lowerThumbCenter - thumbWidth / 2.0, y: 4, width: thumbWidth, height: thumbWidth)
        lowerThumbLayer.setNeedsDisplay()
        lowerThumbTextLayer.frame = CGRect(x: 0, y: 0, width: thumbWidth, height: thumbWidth)
        lowerThumbTextLayer.text = "\(lowerValueInt)"
        lowerThumbTextLayer.setNeedsDisplay()
        
        let upperThumbCenter = CGFloat(positionForValue(value: upperValue, isLower: false))
        upperThumbLayer.frame = CGRect(x: upperThumbCenter - thumbWidth / 2.0, y: 4, width: thumbWidth, height: thumbWidth)
        upperThumbLayer.setNeedsDisplay()
        upperThumbTextLayer.frame = CGRect(x: 0, y: 0, width: thumbWidth, height: thumbWidth)
        upperThumbTextLayer.text = upperValueInt == Int(maximumValue) ? "\(upperValueInt)+" : "\(upperValueInt)"
        upperThumbTextLayer.setNeedsDisplay()
        
        CATransaction.commit()
    }
    
    func positionForValue(value: Double, isLower: Bool) -> Double {
        let position = Double(bounds.width - 2 * thumbWidth) * (value - minimumValue) / (maximumValue - minimumValue) + Double(isLower ? 0 : thumbWidth)
        return position + thumbWidth / 2
    }
    
    func boundValue(value: Double, toLowerValue lowerValue: Double, upperValue: Double) -> Double {
        let boundValue = min(max(value, lowerValue), upperValue)
        return boundValue
    }
    
    // MARK: - Private methods
    
    private func commonInit() {
        trackLayer.rangeSlider = self
        layer.addSublayer(trackLayer)
        
        let uiFont = UIFont.roboto(style: .medium, size: 12)
        
        lowerThumbTextLayer.backgroundColor = UIColor.clear
        lowerThumbTextLayer.textColor = UIColor.white
        lowerThumbTextLayer.font = uiFont
        lowerThumbTextLayer.textAlignment = .center
        
        lowerThumbLayer.rangeSlider = self
        lowerThumbLayer.addSublayer(lowerThumbTextLayer.layer)
        layer.addSublayer(lowerThumbLayer)
        
        upperThumbTextLayer.backgroundColor = UIColor.clear
        upperThumbTextLayer.textColor = UIColor.white
        upperThumbTextLayer.font = uiFont
        upperThumbTextLayer.textAlignment = .center
        
        upperThumbLayer.rangeSlider = self
        upperThumbLayer.addSublayer(upperThumbTextLayer.layer)
        layer.addSublayer(upperThumbLayer)
        
        updateLayerFrames()
    }
    
}
