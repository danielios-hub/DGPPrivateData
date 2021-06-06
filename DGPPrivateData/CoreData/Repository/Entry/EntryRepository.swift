//
//  EntryRepository.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 23/5/21.
//

import Foundation
import CoreData

enum EntryResult {
    case success(Entry)
    case failure(Error)
}

protocol EntryService {
    func create(entry: Entry) -> EntryResult
    func update(entry: Entry) -> EntryResult
    func get(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Result<[Entry], Error>
}

enum RepositoryError: Error {
    case invalidObjectId
}

class EntryRepository: EntryService {
    
    let repository: CoreDataRepository<EntryMO>
    let categoryRepository: CoreDataRepository<CategoryMO>
    
    init(context: NSManagedObjectContext) {
        self.repository = CoreDataRepository<EntryMO>(context: context)
        self.categoryRepository = CoreDataRepository<CategoryMO>(context: context)
    }
    
    func create(entry: Entry) -> EntryResult {
        
        let result = repository.create()
        switch result {
        case let .success(entryMO):
            entryMO.title = entry.title
            entryMO.username = entry.username
            entryMO.password = entry.password
            entryMO.url = entry.url
            entryMO.notes = entry.notes
            entryMO.favorite = entry.favorite
            entryMO.icon = entry.icon

            let predicate = NSPredicate(format: "name == %@", entry.category.name)
            let categoryResult = categoryRepository.get(predicate: predicate, sortDescriptor: nil)
            
            switch categoryResult {
            case let .success(categories):
                entryMO.relationCategory = categories.first!
                return .success(entryMO.toDomainModel())
            case let .failure(error):
                return .failure(error)
            }
        case let .failure(error):
            return .failure(error)
        }
    }
    
    func update(entry: Entry) -> EntryResult {
        guard let id = entry.id,
              let entryMO = repository.get(objectID: id) as? EntryMO else {
            return .failure(RepositoryError.invalidObjectId)
        }
   
        entryMO.title = entry.title
        entryMO.username = entry.username
        entryMO.password = entry.password
        entryMO.url = entry.url
        entryMO.notes = entry.notes
        entryMO.favorite = entry.favorite
        entryMO.icon = entry.icon

        let categoryMO = repository.get(objectID: entry.category.id)
        entryMO.relationCategory = categoryMO as? CategoryMO
        return .success(entryMO.toDomainModel())
    }
    
    func get(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]? = nil) -> Result<[Entry], Error> {
        let result = repository.get(predicate: predicate, sortDescriptor: sortDescriptors)
        switch result {
        case let .success(entries):
            return .success(entries.map {
                $0.toDomainModel()
            })
        case let .failure(error):
            return .failure(error)
        }
    }
}
