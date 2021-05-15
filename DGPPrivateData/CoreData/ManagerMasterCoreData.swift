//
//  ManagerMasterCoreData.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 18/2/21.
//

import Foundation
import CoreData
import Promises

public protocol MasterDataSource {
    func getAllCategories(completionHandler: ([Category]) -> Void)
    func getAllEntrys(filterByCategoryName: [String], completionHandler: ([Entry]) -> Void)
    func createEntry(with title: String?, username: String?, password: String?, notes: String?, isFavorite: Bool, category: Category?) throws -> Entry
    func getDefaultCategory() -> Category?
}

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
    
    public func getAllEntrys(filterByCategoryName: [String]) -> [Entry] {
        guard let context = ManagerCoreDataStack.shared.managedObjectContext else {
            return []
        }
        
        var result: [Entry] = []
        context.performAndWait {
            let request = Entry.entryFetchRequest()
            
            var predicates: [NSPredicate] = []
            if filterByCategoryName.isNotEmpty {
                predicates.append(NSPredicate(format: "ANY relationCategory.name in %@", filterByCategoryName))
            }
            
            if filterByCategoryName.contains("Favorites") {
                predicates.append(NSPredicate(format: "favorite = true"))
            }
            
            request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
            
            if let resultList = try? context.fetch(request) {
                result = resultList
            }
        }
        
        return result
    }
    
    public func getAllEntrys(filterByCategoryName: [String], completionHandler: ([Entry]) -> Void) {
        let entrys = getAllEntrys(filterByCategoryName: filterByCategoryName)
        completionHandler(entrys)
    }
    
    public func getAllCategories(completionHandler: ([Category]) -> Void) {
        let categories = getAllCategories()
        completionHandler(categories)
    }
    
//    public func getAllCategoriesPromise() -> Promise<[Category]> {
//        return Promise<[Category]>(on: .global()) { fullfill, reject in
//            guard let context = ManagerCoreDataStack.shared.managedPrivateObjectContext else {
//                throw CoreDataError.noData
//            }
//            
//            let request = Category.categoryFetchRequest()
//            guard let result = try? context.fetch(request) else {
//                throw CoreDataError.noData
//            }
//            
//            DispatchQueue.main.async {
//                fullfill(result)
//            }
//        }
//    }
    
    public func getAllCategories() -> [Category] {
        guard let context = ManagerCoreDataStack.shared.managedObjectContext else {
            return []
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Category.entityName())
        
        guard let result = try? context.fetch(request) as? Array<Category> else {
            return []
        }
        
        return result
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
    
    public func createEntry(with title: String? = nil,
                            username: String? = nil,
                            password: String? = nil,
                            notes: String? = nil,
                            isFavorite: Bool,
                            category: Category? = nil) throws -> Entry {
        guard let context = ManagerCoreDataStack.shared.managedObjectContext else {
            throw CoreDataError.errorSaving("")
        }
        
        guard let selectedCategory = category ?? getDefaultCategory() else {
            throw CoreDataError.errorSaving("")
        }
        
        let entry = Entry(title: title ?? "Default title",
                          username: username,
                          password: password,
                          notes: notes,
                          isFavorite: isFavorite,
                          category: selectedCategory,
                          context: context)
        do {
            try ManagerCoreDataStack.shared.saveContext()
            return entry
        } catch {
            print(error)
            throw CoreDataError.errorSaving("")
        }
    }
    
    public func updateEntry(_ entry: Entry) throws {
        do {
            try ManagerCoreDataStack.shared.saveContext()
        } catch {
            print(error)
            throw CoreDataError.errorSaving("")
        }
    }
    
//    public func createEntry(title: String? = nil, username: String? = nil, password: String? = nil, notes: String? = nil, category: Category? = nil) -> Entry? {
//        guard let context = ManagerCoreDataStack.sharedInstance.managedObjectContext else {
//            return nil
//        }
//
//        guard let selectedCategory = category ?? getDefaultCategory() else {
//            return nil
//        }
//
//        let entry = Entry(title: title ?? "Default title", username: username, password: password, notes: notes, category: selectedCategory, context: context)
//        do {
//            try ManagerCoreDataStack.sharedInstance.saveContext()
//            return entry
//        } catch {
//            print(error)
//            return nil
//        }
//    }
}
