//
//  FieldEntryView.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 19/2/21.
//

import UIKit

public class FieldEntryView: UIView {
    
    public var textField: UITextField!
    public var titleLabel: UILabel!
    
    static let MARGIN_TEXTFIELD: CGFloat = 0
    
    var titleFont: UIFont? {
        didSet {
            titleLabel.font = titleFont
        }
    }
    
    var textFieldFont: UIFont? {
        didSet {
            textField.font = textFieldFont
        }
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        textField = UITextField()
        titleLabel = UILabel()
        let separator = UIView()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(textField)
        addSubview(titleLabel)
        addSubview(separator)
        
        NSLayoutConstraint.activate( [
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: FieldEntryView.MARGIN_TEXTFIELD),
            
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            textField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: FieldEntryView.MARGIN_TEXTFIELD),
            
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            
        ])
        
        separator.backgroundColor = .silver
        
        titleLabel.textColor = .black
        textField.textColor = .black_midnight_light
    
    }
    
}
