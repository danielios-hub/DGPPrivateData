//
//  EntryMO+CoreDataProperties.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 22/5/21.
//
//

import Foundation
import CoreData


extension EntryMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EntryMO> {
        return NSFetchRequest<EntryMO>(entityName: "EntryMO")
    }

    @NSManaged public var expires: Date?
    @NSManaged public var favorite: Bool
    @NSManaged public var icon: String?
    @NSManaged public var notes: String?
    @NSManaged public var password: String?
    @NSManaged public var title: String
    @NSManaged public var url: String?
    @NSManaged public var username: String?
    @NSManaged public var relationCategory: CategoryMO?

}

extension EntryMO : Identifiable {

}
