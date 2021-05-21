//
//  AuthenticationView.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 5/3/21.
//

import UIKit

class AuthenticationView: UIView {
    
    @IBOutlet weak var authButton: UIButton!
    
    public func setup() {
        
        authButton.clipsToBounds = true
        authButton.layer.cornerRadius = 6
        authButton.backgroundColor = UIColor.forgottenPurple
        authButton.setTitleColor(.white, for: .normal)
        
    }
    
}
