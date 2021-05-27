//
//  CategoryMO+CoreDataProperties.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 22/5/21.
//
//

import Foundation
import CoreData


extension CategoryMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryMO> {
        return NSFetchRequest<CategoryMO>(entityName: "CategoryMO")
    }

    @NSManaged public var icon: String
    @NSManaged public var name: String
    @NSManaged public var entrys: NSSet?

}

// MARK: Generated accessors for entrys
extension CategoryMO {

    @objc(addEntrysObject:)
    @NSManaged public func addToEntrys(_ value: EntryMO)

    @objc(removeEntrysObject:)
    @NSManaged public func removeFromEntrys(_ value: EntryMO)

    @objc(addEntrys:)
    @NSManaged public func addToEntrys(_ values: NSSet)

    @objc(removeEntrys:)
    @NSManaged public func removeFromEntrys(_ values: NSSet)

}

extension CategoryMO : Identifiable {

}
