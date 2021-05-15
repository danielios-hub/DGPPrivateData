//
//  Category+CoreDataProperties.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 15/5/21.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var icon: String
    @NSManaged public var name: String
    @NSManaged public var entrys: NSSet?

}

// MARK: Generated accessors for entrys
extension Category {

    @objc(addEntrysObject:)
    @NSManaged public func addToEntrys(_ value: Entry)

    @objc(removeEntrysObject:)
    @NSManaged public func removeFromEntrys(_ value: Entry)

    @objc(addEntrys:)
    @NSManaged public func addToEntrys(_ values: NSSet)

    @objc(removeEntrys:)
    @NSManaged public func removeFromEntrys(_ values: NSSet)

}

extension Category : Identifiable {

}
