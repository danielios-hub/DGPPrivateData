//
//  ManagerMasterCoreData.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 18/2/21.
//

import Foundation
import CoreData

protocol MasterDataSource {
    func getAllCategories() -> [Category]
    func getAllEntrys(filterByCategoryName: [String]) -> [Entry]
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
    
    func getAllEntrys(filterByCategoryName: [String]) -> [Entry] {
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

/*
public class ManagerMasterCoreData: MasterDataSource {
    
    enum CoreDataError: Error {
        case errorSaving(String)
        case noData
    }
    
    static let shared = ManagerMasterCoreData()
    
    static let defaultCategoryIndex: Int = 0
    
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
    
    private init() {
        if getAllCategories().isEmpty {
            createDefaultData()
        }
    }
    
    func getAllEntrys(filterByCategoryName: [String]) -> [EntryViewModel] {
        var result: [EntryViewModel] = []
        
        let context = ManagerCoreDataStack.shared.managedObjectContext
        
        context?.performAndWait {
            let request = Entry.entryFetchRequest()
            
            var predicates: [NSPredicate] = []
            if filterByCategoryName.isNotEmpty {
                predicates.append(NSPredicate(format: "ANY relationCategory.name in %@", filterByCategoryName))
            }
            
            if filterByCategoryName.contains("Favorites") {
                predicates.append(NSPredicate(format: "favorite = true"))
            }
            
            request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
            
            guard let resultList = try? context?.fetch(request) else {
                return
            }
            
            result = resultList.compactMap { entry in
                return EntryViewModel(from: entry)
            }
        }
        
        return result
    }
    
    func getAllCategories() -> [Category] {
        var categoriesList = [Category]()
        
        let context = ManagerCoreDataStack.shared.managedObjectContext
        context?.performAndWait {
            let request = Category.categoryFetchRequest()
            guard let result = try? context?.fetch(request) else {
                return
            }
            
            categoriesList = result.map {
                return CategoryViewModel(from: $0)
            }
        }
        return categoriesList
    }
    
    public func getDefaultCategory() -> Category? {
        let name = nameCategories[ManagerMasterCoreData.defaultCategoryIndex]
        
        guard let context = ManagerCoreDataStack.shared.managedObjectContext else {
            return nil
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Category.entityName())
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "\(CategoryAttributes.name.rawValue)=%@", name)
        request.fetchLimit = 1
        if let result = try? context.fetch(request) as? Array<Category>, !result.isEmpty {
            return result[0]
        } else {
            createDefaultData()
            return getDefaultCategory()
        }
        
    }
    
    public func createDefaultData() {
        
        guard let context = ManagerCoreDataStack.shared.managedObjectContext else {
            print("Failed to created initial data")
            fatalError()
        }
        
        for (index, name) in nameCategories.enumerated() {
            let _ = Category(name: name, icon: iconCategories[index], selected: true, context: context)
        }
        
        do {
            try ManagerCoreDataStack.shared.saveContext()
        } catch {
            print(error)
        }
    }
    
    func createEntry(with title: String,
                            username: String? = nil,
                            password: String? = nil,
                            notes: String? = nil,
                            isFavorite: Bool,
                            category: Category) throws -> Entry {
        var entry: Entry?
        let context = ManagerCoreDataStack.shared.managedObjectContext
        
        context?.performAndWait {
            guard let selectedCategory = category ?? getDefaultCategory() else {
                throw CoreDataError.errorSaving("")
            }
            let entry = Entry(title: title,
                              username: username,
                              password: password,
                              notes: notes,
                              isFavorite: isFavorite,
                              category: selectedCategory,
                              context: context)
        }
        
        self.save()
        return entry
    }
    
    public func updateEntry(_ entry: Entry) throws {
        do {
            try ManagerCoreDataStack.shared.saveContext()
        } catch {
            print(error)
            throw CoreDataError.errorSaving("")
        }
    }
    
    func save() {
        do {
            try ManagerCoreDataStack.shared.saveContext()
        } catch {
            print(error)
            throw CoreDataError.errorSaving("")
        }
    }
    
    
}
*/
