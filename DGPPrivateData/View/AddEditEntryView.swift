//
//  AddEntryView.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 19/2/21.
//

import UIKit

public class AddEditEntryView: UIView {
    
    //MARK: - Outlets
    
    @IBOutlet var viewTitle: FieldEntryView!
    @IBOutlet var viewUsername: FieldEntryView!
    @IBOutlet var viewPassword: FieldEntryView!
    
    @IBOutlet var textViewNotes: UITextView!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var labelCategoryTitle: UILabel!
    @IBOutlet var iconCategory: UIImageView!
    @IBOutlet var valueCategory: UILabel!
    @IBOutlet var buttonCategory: UIButton!
    @IBOutlet var favoriteButton: NeumorphismButton!
    
    //MARK: - Instance properties
    
    let titleFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
    let valueFont = UIFont.systemFont(ofSize: 15, weight: .regular)
    
    public func setup(target: Any, actionEdit: Selector, actionCopy: Selector) {
        self.backgroundColor = UIColor.element
        textViewNotes.layer.cornerRadius = Constants.cornerRadius
        
        viewTitle.titleLabel.text = NSLocalizedString("Title", comment: "title of the entry")
        viewTitle.textField.placeholder = NSLocalizedString("Write a title", comment: "placeholder of the title of the entry")
        
        viewUsername.titleLabel.text = NSLocalizedString("Username", comment: "title of the username")
        viewUsername.textField.placeholder = NSLocalizedString("Write an username", comment: "placeholder for the field username")
        
        viewPassword.titleLabel.text = NSLocalizedString("Password", comment: "title of the password")
        viewPassword.textField.text = ""
        
        viewPassword.textField.isSecureTextEntry = true
        
        viewTitle.titleFont = titleFont
        viewTitle.textFieldFont = valueFont
        
        viewPassword.titleFont = titleFont
        viewPassword.textFieldFont = valueFont
        
        viewUsername.titleFont = titleFont
        viewUsername.textFieldFont = valueFont
        
        textViewNotes.font = valueFont
        
        labelCategoryTitle.font = titleFont
        valueCategory.font = valueFont
        
        viewPassword.setButtonsPassword(target: target,
                                        actionEdit: actionEdit,
                                        actionCopy: actionCopy)
        
        textViewNotes.addToolbar()
    }
    
    func updateCategory(name: String, icon: String) {
        valueCategory.text = name
        iconCategory.image = UIImage(named: icon)
    }
    
    func updateFavorite(selected: Bool) {
        if selected {
            favoriteButton.setImage(UIImage(symbol: .starFill), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(symbol: .star), for: .normal)
        }
    }
    
    
}




