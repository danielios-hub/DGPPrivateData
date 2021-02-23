//
//  Entry+CoreDataProperties.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 18/2/21.
//
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var title: String
    @NSManaged public var username: String?
    @NSManaged public var password: String?
    @NSManaged public var url: String?
    @NSManaged public var notes: String?
    @NSManaged public var expires: Date?
    @NSManaged public var icon: String
    @NSManaged public var relationCategory: Category?

}

extension Entry : Identifiable {

}
