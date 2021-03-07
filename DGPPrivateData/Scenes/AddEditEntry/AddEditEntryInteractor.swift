//
//  AddEditEntryInteractor.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 4/3/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol AddEditEntryBusinessLogic {
    func loadInitialData(request: AddEditEntryScene.Load.Request)
    func saveEntry(request: AddEditEntryScene.Save.Request)
    func updateEntry(request: AddEditEntryScene.Save.Request)
    func showEntryToEdit(request: AddEditEntryScene.Edit.Request)
    func updatedCategory(request: AddEditEntryScene.UpdateCategory.Request)
    var entryToEdit: Entry? { get set }
    var title: String { get set }
    var username: String { get set }
    var password: String { get set }
    var notes: String { get set }
    var isValid: Bool { get }
    var selectedIndex: Int { get set }
}

protocol AddEditEntryDataStore {
    var entryToEdit: Entry? { get set }
    var title: String { get set }
    var username: String { get set }
    var password: String { get set }
    var notes: String { get set }
    var isValid: Bool { get }
    var selectedIndex: Int { get set }
}

class AddEditEntryInteractor: AddEditEntryBusinessLogic, AddEditEntryDataStore {
    var presenter: AddEditEntryPresentationLogic?
    var worker: AddEditEntryWorker?
    
    var entryToEdit: Entry?
    var title: String = ""
    var username: String = ""
    var password: String = ""
    var notes: String = ""
    
    var categories = [Category]()
    var selectedIndex: Int = 0
    
    // MARK: Input
    
    func loadInitialData(request: AddEditEntryScene.Load.Request) {
        worker = AddEditEntryWorker()
        worker?.fetchCategories { [weak self] categories in
            self?.categories = categories
            self?.selectedIndex = ManagerMasterCoreData.defaultCategoryIndex
            let response = AddEditEntryScene.Load.Response(categories: categories)
            self?.presenter?.presentInitialData(response: response)
        }
    }
    
    func saveEntry(request: AddEditEntryScene.Save.Request) {
        worker = AddEditEntryWorker()
        let category = categories[selectedIndex]
        
        
        worker?.createEntry(with: request.entryFormFields, category: category, completionHandler: { [weak self] result in
            switch result {
            case .success(let entry):
                let response = AddEditEntryScene.Save.Response(entry: entry)
                self?.presenter?.presentCreatedEntry(response: response)
            case .failure(let error):
                self?.presenter?.presentError(error: error)
            }
        })
    }
    
    func updateEntry(request: AddEditEntryScene.Save.Request) {
        guard let entryToEdit = entryToEdit else {
            print("no entity edit to save")
            self.presenter?.presentError(error: AddEditEntryScene.AddEditError.entityNotPresent)
            return
        }
        
        worker = AddEditEntryWorker()
        let category = categories[selectedIndex]
        let entity = buildEntryFromFields(entity: entryToEdit, fields: request.entryFormFields, category: category)
        worker?.editEntry(entry: entity) { [weak self] result in
            switch result {
            case .success(let entity):
                let response = AddEditEntryScene.Save.Response(entry: entity)
                self?.presenter?.presentUpdatedEntry(response: response)
            case .failure(let error):
                self?.presenter?.presentError(error: error)
            }
        }
        
        
    }
    
    func showEntryToEdit(request: AddEditEntryScene.Edit.Request) {
        if let entryToEdit = entryToEdit,
           let category = entryToEdit.relationCategory {
            selectedIndex = categories.firstIndex(of: category) ?? 0
            let response = AddEditEntryScene.Edit.Response(entry: entryToEdit)
            self.presenter?.presentEntryToEdit(response: response)
            
        }
    }
    
    func updatedCategory(request: AddEditEntryScene.UpdateCategory.Request) {
        let selectedCategory = categories[selectedIndex]
        let response = AddEditEntryScene.UpdateCategory.Response(category: selectedCategory)
        self.presenter?.presentSelectedCategory(response: response)
    }
    
    //MARK: - Utils
    
    private func buildEntryFromFields(entity: Entry, fields: AddEditEntryScene.EntryFormFields, category: Category) -> Entry {
        entity.title = fields.title
        entity.username = fields.username
        entity.password = fields.password
        entity.notes = fields.notes
        entity.relationCategory = category
        return entity
    }
    
    var isValid:  Bool {
        return !title.isEmpty || !username.isEmpty || !password.isEmpty || !notes.isEmpty
    }
    
    
}
