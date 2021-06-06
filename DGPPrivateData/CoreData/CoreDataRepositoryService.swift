//
//  ManagerMasterCoreData.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 18/2/21.
//

import Foundation
import CoreData

public enum Order {
    case `default`
    case alphabetically
}

public protocol RepositoryService {
    func getAllCategories() -> [Category]
    func createCategory(category: Category) throws -> Category
    func getAllEntries(filters: [FilterType]) -> [Entry]
    func createEntry(_ entry: Entry) throws -> Entry
    func updateEntry(_ entry: Entry) throws -> Entry
}

public class CoreDataRepositoryService: RepositoryService {
    
    enum CoreDataError: Error {
        case errorSaving(String)
        case noData
    }
    
    static let shared = CoreDataRepositoryService()
    
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
    
    public init(stack: CoreDataStack = CoreDataStack()) {
        //self.stack = stack
        mainWork = UnitOfWork(context: stack.managedObjectContext!)
        backgroundWork = UnitOfWork(context: stack.managedPrivateObjectContext!)
    }
    
    //MARK: - Categories
    
    public func getAllCategories() -> [Category] {
        let result = mainWork.categoryRepository.get(predicate: nil)
        switch result {
        case let .success(categories):
            if categories.count < nameCategories.count {
                createDefaultData()
                return getAllCategories()
            }
            return categories
        case .failure(_):
            return []
        }
    }
    
    public func createCategory(category: Category) throws -> Category {
        let result = mainWork.categoryRepository.create(category: category)
        mainWork.saveChanges()
        switch result {
        case let .success(updatedCategory):
            return updatedCategory
        case let .failure(error):
            throw error
        }
    }
    
    //MARK: - Entries
    
    public func getAllEntries(filters: [FilterType]) -> [Entry] {
        let (categories, order, search, isFavorite) = mapFilters(filters: filters)
        
        let predicates = getPredicates(
            categories: categories,
            search: search,
            isFavorite: isFavorite)
        
        
        let combinePredicates: NSCompoundPredicate? = predicates.isEmpty ? nil : NSCompoundPredicate(
            orPredicateWithSubpredicates: predicates)
        
        let descriptors = getSortDescriptors(order: order)
        
        let result = mainWork.entryRepository.get(predicate: combinePredicates,
                                                  sortDescriptors: descriptors)
        switch result {
        case let .success(entries):
            return entries
        case .failure(_):
            return []
        }
    }
    
    @discardableResult
    public func createEntry(_ entry: Entry) throws -> Entry {
        let result = mainWork.entryRepository.create(entry: entry)
        mainWork.saveChanges()
        switch result {
        case let .success(updatedEntry):
            return updatedEntry
        case let .failure(error):
            throw error
        }
    }
    
    public func updateEntry(_ entry: Entry) throws -> Entry {
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
    
    private func mapFilters(filters: [FilterType]) -> (categories: [String], order: Order, search: String, isFavorite: Bool) {
        var categories: [String] = []
        var order = Order.default
        var textSearch = ""
        var isFavoriteSearch: Bool = false
        
        filters.forEach {
            switch $0 {
            case let .categories(names):
                categories.append(contentsOf: names)
            case let .order(typeOrder):
                order = typeOrder
            case let .search(text):
                textSearch = text
            case let .isFavorite(value):
                isFavoriteSearch = value
            }
        }
        
        return (categories, order, textSearch, isFavoriteSearch)
    }
    
    private func getPredicates(categories: [String], search: String, isFavorite: Bool) -> [NSPredicate] {
        var predicates: [NSPredicate] = []
        
        if search.isNotEmpty {
            return [NSPredicate(format: "title CONTAINS[cd] %@", search)]
        }
        
        
        if categories.isNotEmpty {
            predicates.append(NSPredicate(format: "relationCategory.name in %@", categories))
        }
        
        if isFavorite {
            predicates.append(
                NSPredicate(format: "favorite == true"))
        }
        
        return predicates
    }
    
    private func getSortDescriptors(order: Order) -> [NSSortDescriptor] {
        var descritors: [NSSortDescriptor] = []
        
        switch order {
        case .alphabetically:
            descritors = [
                NSSortDescriptor(keyPath: \EntryMO.title, ascending: true),
                NSSortDescriptor(keyPath: \EntryMO.username, ascending: true),
            ]
        default: break
        }
        return descritors
    }
}
