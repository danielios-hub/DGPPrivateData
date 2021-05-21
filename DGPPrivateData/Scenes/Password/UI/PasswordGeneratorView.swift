//
//  PasswordGeneratorView.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 8/3/21.
//

import UIKit

class PasswordGeneratorView: UIView {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var generateButton: NeumorphismButton!
    @IBOutlet var copyButton: NeumorphismButton!
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet var applyButton: UIButton!
    
    struct ViewTraits {
        static let margin: CGFloat = 10
        static let cornerRadius: CGFloat = 6
    }
    
    public func setup() {
        copyButton.setTitle(NSLocalizedString("Copy to clipboard", comment: "button title for copy password to clipboard"),
                            for: .normal)
        generateButton.setTitle(NSLocalizedString("Generate New", comment: "button title for generate password"),
                                for: .normal)
        applyButton.setTitle(NSLocalizedString("Apply changes", comment: "button for update password"),
                             for: .normal)
        styleButton(copyButton)
        styleButton(generateButton)
        applyStyleButton(applyButton)

        self.passwordTextfield.font = .systemFont(ofSize: 15, weight: .regular)
        
        self.tableView.backgroundColor = .clear
        self.backgroundColor = UIColor.element
    }
    
    private func styleButton(_ button: UIButton) {
        button.titleLabel?.font = DefaultStyleElement.fontActionButton
        button.setTitleColor(.black, for: .normal)
    }
    
    private func applyStyleButton(_ button: UIButton) {
        button.titleLabel?.font = DefaultStyleElement.fontActionButton
        button.layer.cornerRadius = ViewTraits.cornerRadius
        
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
        
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowRadius = 0
        button.layer.masksToBounds = false
        button.layer.shadowOpacity = 1
    }
    
    func getHeaderTableView() -> UIView {
        let header = UIView()
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: 100, height: 20))
        label.text = NSLocalizedString("Options", comment: "Header password generate options")
        label.textColor = .forgottenPurple
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        header.addSubview(label)
        return header
    }
    
}



