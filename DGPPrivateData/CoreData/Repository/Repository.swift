//
//  Repository.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 22/5/21.
//

import Foundation

protocol Repository {
    associatedtype Entity
    
    /// get all the entities
    /// - Parameters:
    ///   - predicate: predicate use to fetch the entities
    ///   - sortDescriptor: use for order of the entities
    func get(predicate: NSPredicate?, sortDescriptor: [NSSortDescriptor]?) -> Result<[Entity], Error>
    
    func create() -> Result<Entity, Error>
    
    func delete(entity: Entity) -> Result<Bool, Error>
    
}
