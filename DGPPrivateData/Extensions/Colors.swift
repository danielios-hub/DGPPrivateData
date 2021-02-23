//
//  Colors.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 19/2/21.
//

import UIKit

extension UIColor {
    
    static let emerald = UIColor(hex: 0x009B77)
    static let emeraldDark = UIColor(hex: 0x2D7F77)
    
    static let lightGray = UIColor(hex: 0xecf0f1)
    static let silver = UIColor(hex: 0xbdc3c7)
    
    static let mimosa = UIColor(hex: 0xEFC050)
    static let red_fluorescent = UIColor(hex: 0xff5252)
    
    static let lavender_tea = UIColor(hex: 0xD980FA)
   
    
    // Create a UIColor from RGB
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
    
    // Create a UIColor from a hex value (E.g 0x000000)
    convenience init(hex: Int, a: CGFloat = 1.0) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF,
            a: a
        )
    }
}
