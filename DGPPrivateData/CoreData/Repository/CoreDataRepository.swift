//
//  CoreDataRepository.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 22/5/21.
//

import Foundation
import CoreData

//CoreDataErrors
enum CoreDataError: Error {
    case invalidManagedObjectType
}

/// Generic repository for NSManagedObject
class CoreDataRepository<T: NSManagedObject>: Repository {
    typealias Entity = T
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func get(predicate: NSPredicate?, sortDescriptor: [NSSortDescriptor]?) -> Result<[T], Error> {
        let request = Entity.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sortDescriptor
        
        do {
            if let result = try context.fetch(request) as? Array<Entity> {
                return .success(result)
            } else {
                return .failure(CoreDataError.invalidManagedObjectType)
            }
        } catch {
            return .failure(error)
        }
    }
    
    /// Create a NSManagedObject
    /// - Returns: A result consisting of either a NSManagedObject or an error
    func create() -> Result<T, Error> {
        let className = String(describing: Entity.self)
        
        guard let managedObject = NSEntityDescription.insertNewObject(forEntityName: className, into: context) as? Entity else {
            return .failure(CoreDataError.invalidManagedObjectType)
        }
        return .success(managedObject)
    }
    
    /// Delete a NSManagedObject
    /// - Parameter entity: NSManageObject entity to be deleted
    /// - Returns: A result consisting of either a bool set to true or an error
    func delete(entity: T) -> Result<Bool, Error> {
        context.delete(entity)
        return .success(true)
    }
    
    func get(objectID: String) -> NSManagedObject? {
        if let url = URL(string: objectID) {
            if let objectInternalID = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: url) {
                return context.object(with: objectInternalID)
            }
        }
        return nil
    }
}
