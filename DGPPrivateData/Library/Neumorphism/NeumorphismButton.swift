//
//  NeumorphismButton.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 16/5/21.
//

import UIKit

class NeumorphismButton: UIButton {
    
    var topLeftShadow: CALayer?
    var bottomRightShadow: CALayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    override func draw(_ rect: CGRect) {
        setupLayers()
        super.draw(rect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    override var isHighlighted: Bool {
        didSet {
            topLeftShadow?.shadowColor = isHighlighted ? UIColor.shadow?.cgColor : UIColor.highlight?.cgColor
            bottomRightShadow?.shadowColor = isHighlighted ? UIColor.highlight?.cgColor : UIColor.shadow?.cgColor
        }
    }
    
    func setupView() {
        self.backgroundColor = .element
        self.layer.masksToBounds = false
    }
    
    func setupLayers(cornerRadius: CGFloat = 10, shadowRadius: CGFloat = 2) {
        topLeftShadow = self.setShadowLayer(backgroundColor: UIColor.element?.cgColor, shadowColor: UIColor.highlight?.cgColor, cornerRadius: cornerRadius, shadowRadius: shadowRadius, negativeShadow: true)
        bottomRightShadow = self.setShadowLayer(backgroundColor: UIColor.element?.cgColor, shadowColor: UIColor.shadow?.cgColor, cornerRadius: cornerRadius, shadowRadius: shadowRadius)
    }
    
}
