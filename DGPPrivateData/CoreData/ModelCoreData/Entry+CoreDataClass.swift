//
//  Entry+CoreDataClass.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 18/2/21.
//
//

import Foundation
import CoreData

enum EntryAttributes: String {
    case title = "title"
    case username = "username"
    case password = "password"
    case url = "url"
    case notes = "notes"
    case icon = "icon"
    case expires = "expires"
}

@objc(Entry)
public class Entry: NSManagedObject {

    //MARK: - Class methods
    
    @nonobjc public class func entryFetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }
    
    class func entityName() -> String {
        return "Entry"
    }
    
    class func entity(_ managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }
    
    //MARK: - Init methods
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext!) {
        super.init(entity: entity, insertInto: context)
    }
    
    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = Entry.entity(managedObjectContext)
        self.init(entity: entity!, insertInto: managedObjectContext)
    }
    
    convenience init(title: String,
                     username: String? = nil,
                     password: String? = nil,
                     url: String? = nil,
                     notes: String? = nil,
                     icon: String? = nil,
                     expires: Date? = nil,
                     isFavorite: Bool,
                     category: Category,
                     context: NSManagedObjectContext) {
        self.init(managedObjectContext: context)
        self.title = title
        self.username = username
        self.password = password
        self.url = url
        self.notes = notes
        self.favorite = isFavorite
        self.expires = expires
        self.relationCategory = category
        
        if let icon = icon {
            self.icon = icon
        }
    }
}
