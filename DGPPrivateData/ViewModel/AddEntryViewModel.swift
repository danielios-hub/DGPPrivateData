//
//  AddEntryViewModel.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 22/2/21.
//

import Foundation

public class AddEntryViewModel {
    
    public enum TagTextField: Int {
        case title = 1
        case username = 2
        case password = 3
        case notes = 4
    }
    
    //MARK: - Instance properties
    
    public let dataSource: MasterDataSource
    
    private var categories = [Category]()
    
    private var selectedCategory: Category! {
        didSet {
            updatedCategory?()
        }
    }
    
    public var isSelectingCategory = false {
        didSet {
            if isSelectingCategory != oldValue && isSelectingCategory {
                showCategoriesPickerClosure?()
            }
        }
    }
    
    public var categoryText: String {
        return selectedCategory.name
    }
    
    public var categoryIcon: String {
        return selectedCategory.icon
    }
    
    public var selectedIndex: Int {
        return categories.firstIndex(of: selectedCategory)!
    }
    
    var title: String  = ""
    
    var username: String = ""
    
    var password: String = ""
    
    var notes: String = ""
    
    var alertMessage: String? {
        didSet {
            showAlertClosure?()
        }
    }
    
    var addEntrySuccessClosure: (() -> Void)?
    var showAlertClosure: (() -> Void)?
    var updatedCategory: (() -> Void)?
    var showCategoriesPickerClosure : (() -> Void)?
    
    //MARK: - Life cicle
    
    public init(dataSource: MasterDataSource) {
        self.dataSource = dataSource
    }
    
    public func initFetch() {
        categories = dataSource.getAllCategories()
        selectedCategory = dataSource.getDefaultCategory()!
    }
    
    func isValid() -> Bool {
        return !title.isEmpty || !username.isEmpty || !password.isEmpty || !notes.isEmpty
    }
    
    public func configureTagView(_ entryView: AddEditEntryView) {
        entryView.viewTitle.textField.tag = TagTextField.title.rawValue
        entryView.viewUsername.textField.tag = TagTextField.username.rawValue
        entryView.viewPassword.textField.tag = TagTextField.password.rawValue
        entryView.textViewNotes.tag = TagTextField.notes.rawValue
    }
    
    public func updateText(text: String, tag: Int) {
        switch tag {
        case TagTextField.title.rawValue:
            title = text
        case TagTextField.username.rawValue:
            username = text
        case TagTextField.password.rawValue:
            password = text
        case TagTextField.notes.rawValue:
            notes = text
        default:
            break
        }
        printData()
    }
    
    private func printData() {
        print("title: \(title) \n username: \(username) \n password: \(password) \n notes: \(notes)")
    }
    
    public func createEntry() {
        if let _ = dataSource.createEntry(title: title, username: username, password: password, notes: notes, category: selectedCategory) {
            addEntrySuccessClosure?()
        } else {
            alertMessage = NSLocalizedString("try_again", comment: "error message something went wrong")
        }
    }
}

extension AddEntryViewModel: DGPPickerViewModel {
    
    public func numberOfComponents() -> Int {
        return 1
    }
    
    public func numberOfItems() -> Int {
        return categories.count
    }
    
    public func titleOfItem(with index: Int, component: Int) -> String {
        return categories[index].name
    }
    
    public func didSelectItem(with index: Int, component: Int) -> Void {
        selectedCategory = categories[index]
    }
    
    public func finishDGPPickerView() {
        isSelectingCategory = false
    }
    
}
