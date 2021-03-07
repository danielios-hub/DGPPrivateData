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
    
    @IBOutlet var labelNotes: UILabel!
    @IBOutlet var textViewNotes: UITextView!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var labelCategoryTitle: UILabel!
    @IBOutlet var iconCategory: UIImageView!
    @IBOutlet var valueCategory: UILabel!
    @IBOutlet var buttonCategory: UIButton!
    
    //MARK: - Instance properties
    
    let titleFont = UIFont.systemFont(ofSize: 14, weight: .medium)
    let valueFont = UIFont.systemFont(ofSize: 15, weight: .regular)
    
    public func setup(target: Any, actionEdit: Selector) {
        viewTitle.titleLabel.text = NSLocalizedString("Title", comment: "title of the entry")
        viewTitle.textField.placeholder = NSLocalizedString("Write a title", comment: "placeholder of the title of the entry")
        
        viewUsername.titleLabel.text = NSLocalizedString("Username", comment: "title of the username")
        viewUsername.textField.placeholder = NSLocalizedString("Write an username", comment: "placeholder for the field username")
        
        viewPassword.titleLabel.text = NSLocalizedString("Password", comment: "title of the password")
        viewPassword.textField.text = ""
        
        labelNotes.text = NSLocalizedString("Notes", comment: "title of the notes")
        textViewNotes.text = NSLocalizedString("Write some notes for your entry", comment: "Placeholder notes entry")
        
        viewPassword.textField.isSecureTextEntry = true
        
        viewTitle.titleFont = titleFont
        viewTitle.textFieldFont = valueFont
        
        viewPassword.titleFont = titleFont
        viewPassword.textFieldFont = valueFont
        
        viewUsername.titleFont = titleFont
        viewUsername.textFieldFont = valueFont
        
        labelNotes.font = titleFont
        textViewNotes.font = valueFont
        
        labelCategoryTitle.font = titleFont
        valueCategory.font = valueFont
        
        viewPassword.setButtonsPassword(target: target, actionEdit: actionEdit)
    }
    
    func updateCategory(name: String, icon: String) {
        valueCategory.text = name
        iconCategory.image = UIImage(named: icon)
    }
}
