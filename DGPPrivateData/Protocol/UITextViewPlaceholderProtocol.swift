//
//  UITextViewPlaceholderProtocol.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 22/2/21.
//

import UIKit.UIColor

public protocol UITextViewPlaceholderProtocol {
    var textPlaceholder: String { get }
    var colorPlaceholder: UIColor { get }
    var textView: UITextView? { get }
    func setPlaceholder() -> Void
    func checkEnabledPublish()
    func isEnabledButton(_ enabled: Bool)
    func isValid() -> Bool
}

extension UITextViewPlaceholderProtocol {
    
    var colorPlaceholder: UIColor {
        return UIColor.placeholderText
    }
    
    var textPlaceholder: String {
        return NSLocalizedString("What are you thinking?", comment: "default placeholder for uitextview")
    }
    
    func checkEnabledPublish() {
        isEnabledButton(isValid())
    }
    
    func setPlaceholder() {
        textView?.text = textPlaceholder
        textView?.textColor = colorPlaceholder
    }
    
}
