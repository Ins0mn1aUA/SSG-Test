//
//  BaseButton.swift
//  SSG-test
//
//  Created by Григорий Стеценко on 01.12.2023.
//

import UIKit

class BaseButton: UIButton {

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }

    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        commonInit()
    }
    
    override open var isHighlighted: Bool {
        didSet {
            super.isHighlighted = isHighlighted
            backgroundColor = isHighlighted ? UIColor.appColor(.baseButtonHighlightedBackgroundColor) : .clear
        }
    }
    
    // MARK: - Private methods
    
    private func commonInit() {
        backgroundColor = .clear
        
        titleLabel?.font = UIFont.roboto(style: .medium, size: 13)
        setTitleColor(UIColor.appColor(.mainBlue), for: .normal)
    }
}
