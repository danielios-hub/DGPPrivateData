//
//  FieldEntryView.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 19/2/21.
//

import UIKit

public class FieldEntryView: UIView {
    
    //MARK: - Instance properties

    public var textField: UITextField!
    public var titleLabel: UILabel!
    public var stackButtonView: UIStackView!
    
    private var widthStack: NSLayoutConstraint?
    
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
        stackButtonView = UIStackView()
        let separator = UIView()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stackButtonView.translatesAutoresizingMaskIntoConstraints = false
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(textField)
        addSubview(titleLabel)
        addSubview(stackButtonView!)
        addSubview(separator)
        
        NSLayoutConstraint.activate( [
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: FieldEntryView.MARGIN_TEXTFIELD),
            
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            textField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: stackButtonView.leadingAnchor, constant: -FieldEntryView.MARGIN_TEXTFIELD),
            
            stackButtonView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stackButtonView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -FieldEntryView.MARGIN_TEXTFIELD),
            
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        widthStack = stackButtonView.widthAnchor.constraint(equalToConstant: 0)
        widthStack?.isActive = true 
        separator.backgroundColor = .silver
        
        titleLabel.textColor = .black
        textField.textColor = .black_midnight_light
        stackButtonView.distribution = .equalSpacing
        
    }
    
    func setButtonsPassword(target: Any?,
                            actionEdit: Selector,
                            actionCopy: Selector) {
        widthStack?.constant = 100
        let buttonEdit = UIButton()
        buttonEdit.setImage(UIImage(symbol: .pencilCircleFill), for: .normal)
        
        let buttonShow = UIButton()
        buttonShow.setImage(UIImage(symbol: .eyeFill), for: .normal)
        
        let buttonCopy = UIButton()
        buttonCopy.setImage(UIImage(symbol: .docFill), for: .normal)
        
        stackButtonView?.addArrangedSubview(buttonEdit)
        stackButtonView?.addArrangedSubview(buttonShow)
        stackButtonView?.addArrangedSubview(buttonCopy)
        
        buttonEdit.tintColor = .lavenderTea
        buttonShow.tintColor = .lavenderTea
        buttonCopy.tintColor = .lavenderTea
        
        buttonEdit.addTarget(target, action: actionEdit, for: .touchUpInside)
        buttonShow.addTarget(self, action: #selector(toggleSecureTextEntry), for: .touchUpInside)
        buttonCopy.addTarget(target, action: actionCopy, for: .touchUpInside)
    }
    
    @objc func toggleSecureTextEntry() {
        textField.isSecureTextEntry.toggle()
    }
    
}
