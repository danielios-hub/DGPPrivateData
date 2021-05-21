//
//  Colors.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 19/2/21.
//

import UIKit

extension UIColor {
    
    static let emerald = UIColor(named: "emerald")
    static let emeraldDark = UIColor(named: "emeraldDark")
    
    static let lightGray = UIColor(named: "lightGray")
    static let silver = UIColor(named: "silver")
    
    static let mimosa = UIColor(named: "mimosa")
    static let lavenderTea = UIColor(named: "lavenderTea")
    static let forgottenPurple = UIColor(named: "forgottenPurple")
    static let berry = UIColor(named: "berry")
    
    static let grayDark = UIColor(named: "grayDark")
    static let redFluorescent = UIColor(named: "redFluorescent")
    
//    static let element = UIColor(named: "Element")
//    static let highlight = UIColor(named: "Highlight")
//    static let shadow = UIColor(named: "Shadow")
   
    
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
