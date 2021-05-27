//
//  EntryRepository.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 23/5/21.
//

import Foundation
import CoreData

protocol EntryService {
    func create(entry: Entry) -> Result<Bool, Error>
    func get(predicate: NSPredicate?) -> Result<[Entry], Error>
}

class EntryRepository: EntryService {
    
    let repository: CoreDataRepository<EntryMO>
    
    init(context: NSManagedObjectContext) {
        self.repository = CoreDataRepository<EntryMO>(context: context)
    }
    
    func create(entry: Entry) -> Result<Bool, Error> {
        
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
            
            //fixme category
            let category = entry.category
            
            return .success(true)
        case let .failure(error):
            return .failure(error)
        }
    }
    
    func get(predicate: NSPredicate?) -> Result<[Entry], Error> {
        let result = repository.get(predicate: predicate, sortDescriptor: nil)
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
