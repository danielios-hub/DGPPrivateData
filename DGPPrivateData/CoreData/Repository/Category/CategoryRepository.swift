//
//  CategoryRepository.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 22/5/21.
//

import Foundation
import CoreData

enum CategoryResult {
    case success(Category)
    case failure(Error)
}

protocol CategoryService {
    func create(category: Category) -> CategoryResult
    func get(predicate: NSPredicate?) -> Result<[Category], Error>
}

class CategoryRepository: CategoryService {
    
    let repository: CoreDataRepository<CategoryMO>
    
    init(context: NSManagedObjectContext) {
        self.repository = CoreDataRepository<CategoryMO>(context: context)
    }
    
    func get(predicate: NSPredicate?) -> Result<[Category], Error> {
        let descriptors = [NSSortDescriptor(keyPath: \CategoryMO.name, ascending: true)]
        let result = repository.get(predicate: predicate, sortDescriptor: descriptors)
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
    func create(category: Category) -> CategoryResult {
        let result = repository.create()
        switch result {
        case let .success(categoryMO):
            categoryMO.name = category.name
            categoryMO.icon = category.icon
            return .success(categoryMO.toDomainModel())
        case let .failure(error):
            return .failure(error)
        }
    }
    
    
    
    
}
