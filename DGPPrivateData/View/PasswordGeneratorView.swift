//
//  PasswordGeneratorView.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 8/3/21.
//

import UIKit

class PasswordGeneratorView: UIView {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var generateButton: UIButton!
    @IBOutlet var copyButton: UIButton!
    @IBOutlet var passwordLabel: UILabel!
    @IBOutlet var applyButton: UIButton!
    
    struct ViewTraits {
        static let margin: CGFloat = 10
        static let cornerRadius: CGFloat = 6
    }
    
    public func setup() {
        copyButton.backgroundColor = .lavenderTea
        generateButton.backgroundColor = .lavenderTea
        
        copyButton.setTitle(NSLocalizedString("Copy to clipboard", comment: "button title for copy password to clipboard"),
                            for: .normal)
        generateButton.setTitle(NSLocalizedString("Generate New", comment: "button title for generate password"),
                                for: .normal)
        applyButton.setTitle(NSLocalizedString("Apply changes", comment: "button for update password"),
                             for: .normal)
        applyStyleButton(copyButton)
        applyStyleButton(generateButton)
        applyStyleButton(applyButton)
        
        passwordLabel.font = .systemFont(ofSize: 15, weight: .regular)
    }
    
    private func applyStyleButton(_ button: UIButton) {
        button.clipsToBounds = true
        button.layer.cornerRadius = ViewTraits.cornerRadius
        button.backgroundColor = .lavenderTea
        button.titleLabel?.font = DefaultStyleElement.fontActionButton
        button.setTitleColor(.white, for: .normal)
    }
}
