//
//  AddEditEntryWorker.swift
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

class AddEditEntryWorker {
    func fetchCategories(completionHandler: @escaping (([Category]) -> Void)) {
        ManagerMasterCoreData.sharedInstance.getAllCategories { categories in
            completionHandler(categories)
        }
    }
    
    func createEntry(with formFields: AddEditEntryScene.EntryFormFields, category: Category, completionHandler: @escaping ((Result<Entry, Error>) -> Void)) {
        do {
            let entry = try ManagerMasterCoreData.sharedInstance.createEntry(with: formFields.title, username: formFields.username, password: formFields.password, notes: formFields.notes, category: category)
            completionHandler(.success(entry))
        } catch {
            completionHandler(.failure(error))
        }
    }
    
    func editEntry(entry: Entry, completionHandler: @escaping ((Result<Entry, Error>) -> Void)) {
        do {
            try ManagerMasterCoreData.sharedInstance.updateEntry(entry)
            completionHandler(.success(entry))
        } catch {
            completionHandler(.failure(error))
        }
    }
}