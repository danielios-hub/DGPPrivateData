//
//  UITextfieldTextview.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 27/5/21.
//

import UIKit

extension UITextField {
    
    func addToolbar(target: Any? = nil, action: Selector? = nil) {
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 44)
        let toolbar = UIToolbar(frame: frame)
        
        let doneButton: UIBarButtonItem
        if let target = target, let action = action {
            doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: target, action: action)
        } else {
            doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(hideSelf))
        }
        
        toolbar.setItems([UIBarButtonItem(systemItem: .flexibleSpace), doneButton], animated: true)
        
        self.inputAccessoryView = toolbar
    }
    
    @objc func hideSelf() {
        self.resignFirstResponder()
    }
}

extension UITextView {
    
    func addToolbar(target: Any? = nil, action: Selector? = nil) {
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 40)
        let toolbar = UIToolbar(frame: frame)
        
        let doneButton: UIBarButtonItem
        if let target = target, let action = action {
            doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: target, action: action)
        } else {
            doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(hideSelf))
        }
        
        toolbar.setItems([UIBarButtonItem(systemItem: .flexibleSpace), doneButton], animated: true)
        
        self.inputAccessoryView = toolbar
    }
    
    @objc func hideSelf() {
        self.resignFirstResponder()
    }
}
