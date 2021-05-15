//
//  Category+CoreDataClass.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 18/2/21.
//
//

import Foundation
import CoreData

enum CategoryAttributes: String {
    case name = "name"
    case icon = "icon"
}

@objc(Category)
public class Category: NSManagedObject {
    
    //MARK: - Class methods
    
    class func entityName() -> String {
        return "Category"
    }
    
    class func entity(_ managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }
    
    //MARK: - Init methods
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext!) {
        super.init(entity: entity, insertInto: context)
    }
    
    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = Category.entity(managedObjectContext)
        self.init(entity: entity!, insertInto: managedObjectContext)
    }
    
    convenience init(name: String, icon: String, selected: Bool, context: NSManagedObjectContext) {
        self.init(managedObjectContext: context)
        self.name = name
        self.icon = icon
    }
    

}
