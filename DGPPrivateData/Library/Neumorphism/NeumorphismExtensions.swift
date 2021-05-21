//
//  NeumorphismExtensions.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 16/5/21.
//

import UIKit

extension UIView {
    
    func neumorphism(backgroundColor: UIColor? = UIColor.element, cornerRadius: CGFloat = 10, shadowRadius: CGFloat = 2) {
        self.layer.masksToBounds = false
        self.setShadowLayer(backgroundColor: backgroundColor?.cgColor, shadowColor: UIColor.shadow?.cgColor, cornerRadius: cornerRadius, shadowRadius: shadowRadius)
        self.setShadowLayer(backgroundColor: backgroundColor?.cgColor, shadowColor: UIColor.highlight?.cgColor, cornerRadius: cornerRadius, shadowRadius: shadowRadius, negativeShadow: true)
    }
    
    @discardableResult
    internal func setShadowLayer(backgroundColor: CGColor?, shadowColor: CGColor?, cornerRadius: CGFloat, shadowRadius: CGFloat, negativeShadow: Bool = false) -> CALayer {
        let shadow = CALayer()
        let sizeShadow = negativeShadow ? CGSize(width: -shadowRadius, height: -shadowRadius) : CGSize(width: shadowRadius, height: shadowRadius)
        shadow.frame = self.bounds
        shadow.backgroundColor = backgroundColor
        shadow.shadowColor = shadowColor
        shadow.cornerRadius = cornerRadius
        shadow.shadowOffset = sizeShadow
        shadow.shadowOpacity = 1
        shadow.shadowRadius = shadowRadius
        shadow.cornerRadius = cornerRadius
        self.layer.insertSublayer(shadow, at: 0)
        return shadow
    }
}
