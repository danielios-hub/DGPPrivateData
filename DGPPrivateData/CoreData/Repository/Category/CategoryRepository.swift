//
//  CategoryRepository.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 22/5/21.
//

import Foundation
import CoreData

protocol CategoryService {
    func create(category: Category) -> Result<Bool, Error>
    func get(predicate: NSPredicate?) -> Result<[Category], Error>
}

class CategoryRepository: CategoryService {
    
    let repository: CoreDataRepository<CategoryMO>
    
    init(context: NSManagedObjectContext) {
        self.repository = CoreDataRepository<CategoryMO>(context: context)
    }
    
    func get(predicate: NSPredicate?) -> Result<[Category], Error> {
        let result = repository.get(predicate: predicate, sortDescriptor: nil)
        switch result {
        case let .success(categories):
            return .success(categories.map {
                return $0.toDomainModel()
            })
        case let .failure(error):
            return .failure(error)
        }
    }
    
    @discardableResult
    func create(category: Category) -> Result<Bool, Error> {
        let result = repository.create()
        switch result {
        case let .success(categoryMO):
            categoryMO.name = category.name
            categoryMO.icon = category.icon
            return .success(true)
        case let .failure(error):
            return .failure(error)
        }
    }
    
    
    
    
}
