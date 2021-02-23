//
//  MasterUser+CoreDataClass.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 18/2/21.
//
//

import Foundation
import CoreData

@objc(MasterUser)
public class MasterUser: NSManagedObject {
    
    //MARK: - Class methods
    
    class func entityName() -> String {
        return "MasterUser"
    }
    
    class func entity(_ managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }
    
    //MARK: - Init methods
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext!) {
        super.init(entity: entity, insertInto: context)
    }
    
    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = MasterUser.entity(managedObjectContext)
        self.init(entity: entity!, insertInto: managedObjectContext)
    }
    
    convenience init(hash: String,
                     context: NSManagedObjectContext) {
        self.init(managedObjectContext: context)
        self.masterHash = hash
    }
    
}
