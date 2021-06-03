//
//  ManagerMasterCoreData.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 18/2/21.
//

import Foundation
import CoreData

enum Order {
    case `default`
    case alphabetically
}

protocol MasterDataSource {
    func getAllCategories() -> [Category]
    func getAllEntries(filters: [FilterType]) -> [Entry]
    func createEntry(with title: String, username: String?, password: String?, notes: String?, isFavorite: Bool, category: Category) throws -> Entry
    
    func createEntry(_ entry: Entry) throws -> Entry
    func updateEntry(_ entry: Entry) throws -> Entry
}

class ManagerMasterCoreData: MasterDataSource {
    
    enum CoreDataError: Error {
        case errorSaving(String)
        case noData
    }
    
    static let shared = ManagerMasterCoreData()
    
    static let defaultCategoryIndex: Int = 0
    
    var mainWork: UnitOfWork
    var backgroundWork: UnitOfWork
    
    let nameCategories = [
        "General",
        "SocialNetwork",
        "Email",
        "Network",
        "Internet",
        "Bank"
    ]
    
    let iconCategories = [
        "folder",
        "social",
        "email",
        "wifi",
        "internet",
        "creditcard"
    ]
    
    init() {
        let stack = ManagerCoreDataStack()
        mainWork = UnitOfWork(context: stack.managedObjectContext!)
        backgroundWork = UnitOfWork(context: stack.managedPrivateObjectContext!)
    }
    
    func getAllCategories() -> [Category] {
        let result = mainWork.categoryRepository.get(predicate: nil)
        switch result {
        case let .success(categories):
            if categories.isEmpty {
                createDefaultData()
                return getAllCategories()
            }
            return categories
        case .failure(_):
            return []
        }
    }
    
    func getAllEntries(filters: [FilterType]) -> [Entry] {
        let result = mainWork.entryRepository.get(predicate: nil)
        switch result {
        case let .success(entries):
            return entries
        case .failure(_):
            return []
        }
    }
    
    func createEntry(with title: String,
                     username: String?,
                     password: String?,
                     notes: String?,
                     isFavorite: Bool,
                     category: Category) throws -> Entry {
        let entry = Entry(title: title, username: username , password: password, url: "", notes: notes, favorite: isFavorite, icon: "default_icon", category: category)
        let result = mainWork.entryRepository.create(entry: entry)
        mainWork.saveChanges()
        switch result {
        case .success(_):
            return entry
        case let .failure(error):
            throw error
        }
    }
    
    func createEntry(_ entry: Entry) throws -> Entry {
        let result = mainWork.entryRepository.create(entry: entry)
        mainWork.saveChanges()
        switch result {
        case .success(_):
            return entry
        case let .failure(error):
            throw error
        }
    }
    
    func updateEntry(_ entry: Entry) throws -> Entry {
        let result = mainWork.entryRepository.update(entry: entry)
        mainWork.saveChanges()
        switch result {
        case .success(_):
            return entry
        case let .failure(error):
            throw error
        }
    }
    
    //MARK: - Helpers
    
    public func createDefaultData() {
        for (index, name) in nameCategories.enumerated() {
            mainWork.categoryRepository.create(
                category: Category(name: name,
                                   icon: iconCategories[index])
            )
        }
        
        mainWork.saveChanges()
    }
}
