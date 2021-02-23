//
//  AddEntryVC.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 19/2/21.
//

import UIKit

class AddEditVC: UIViewController, Storyboarded {
    
    //MARK: - Instance properties
    
    public var viewModel: AddEntryViewModel!
    public weak var coordinator: AddEntryCoordinator?
    
    private var addEntryView: AddEditEntryView! {
        guard isViewLoaded else {
            return nil
        }
        return (view as! AddEditEntryView)
    }
    
    var textPlaceholder: String = NSLocalizedString("Add anything you want to save", comment: "placeholder for the notes textView")
    
    var textView: UITextView? {
        return addEntryView?.textViewNotes
    }
    
    //MARK: - Life cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewModel()
        setPlaceholder()
    }
    
    private func setupView() {
        addEntryView.setup()
        navigationItem.title = NSLocalizedString("Add an Item", comment: "title of the add entry screen")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveEntry))
        addEntryView.viewTitle.textField.delegate = self
        addEntryView.viewUsername.textField.delegate = self
        addEntryView.viewPassword.textField.delegate = self
        addEntryView.textViewNotes.delegate = self
        isEnabledButton(false)
        
        addEntryView.buttonCategory.addTarget(self, action: #selector(selectCategory), for: .touchUpInside)
    }
    
    private func setupViewModel() {
        viewModel.configureTagView(addEntryView)
        addObserver(addEntryView.viewTitle.textField)
        addObserver(addEntryView.viewUsername.textField)
        addObserver(addEntryView.viewPassword.textField)
        
        viewModel.showAlertClosure = { [weak self] in
            if let message = self?.viewModel.alertMessage {
                self?.view.makeToast(message, position: .bottom)
            }
        }
        
        viewModel.addEntrySuccessClosure = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        viewModel.updatedCategory = { [weak self] in
            if let viewModel = self?.viewModel {
                self?.addEntryView.updateCategory(name: viewModel.categoryText, icon: viewModel.categoryIcon)
            }
        }
        
        
        viewModel.showCategoriesPickerClosure = { [weak self] in
            if let view = self?.view, let model = self?.viewModel {
                let picker = DGPPickerView(frame: .zero, viewModel: model)
                picker.show(in: view)
            }
        }
        
        viewModel.initFetch()
    }
    
    //MARK: - Actions
    
    @objc func saveEntry() {
        viewModel.createEntry()
    }
    
    @objc func selectCategory() {
        viewModel.isSelectingCategory = true
    }
    
    func isEnabledButton(_ enabled: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = enabled
    }
    
    func isValid() -> Bool {
        return viewModel.isValid()
    }
    
    
    
}

//MARK: - UITextField Delegate

extension AddEditVC: UITextFieldDelegate {
    
    func addObserver(_ textField: UITextField) {
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.autocorrectionType = .no
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        viewModel.updateText(text: textField.text!, tag: textField.tag)
        checkEnabledPublish()
    }
}

//MARK: - UITextView Delegate

extension AddEditVC: UITextViewDelegate, UITextViewPlaceholderProtocol {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        if updatedText.isEmpty {
            setPlaceholder()
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            updateViewModelText(textView: textView)
            checkEnabledPublish()
        }

         else if textView.textColor == colorPlaceholder && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
            
            updateViewModelText(textView: textView)
            checkEnabledPublish()
        } else {
            return true
        }

        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == colorPlaceholder {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        checkEnabledPublish()
        updateViewModelText(textView: textView)
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.text = textView.text.trimming()
    }
    
    func updateViewModelText(textView: UITextView) {
        viewModel.updateText(text: textView.text! == textPlaceholder ? "" : textView.text!, tag: textView.tag)
    }
}
