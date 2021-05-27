//
//  UnitOfWork.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 23/5/21.
//

import Foundation
import CoreData

final class UnitOfWork {
    private let context: NSManagedObjectContext
    
    let categoryRepository: CategoryRepository
    let entryRepository: EntryRepository
    
    init(context: NSManagedObjectContext) {
        self.context = context
        self.categoryRepository = CategoryRepository(context: context)
        self.entryRepository = EntryRepository(context: context)
    }
    
    @discardableResult
    func saveChanges() -> Result<Bool, Error> {
        if context.hasChanges{
            do {
                try context.save()
                return .success(true)
            }
            catch {
                return .failure(error)
            }
        } else {
            return .success(true)
        }
        
    }
}
