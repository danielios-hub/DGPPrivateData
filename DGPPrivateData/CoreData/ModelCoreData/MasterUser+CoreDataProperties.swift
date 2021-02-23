//
//  MasterUser+CoreDataProperties.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 18/2/21.
//
//

import Foundation
import CoreData


extension MasterUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MasterUser> {
        return NSFetchRequest<MasterUser>(entityName: "MasterUser")
    }

    @NSManaged public var masterHash: String?

}

extension MasterUser : Identifiable {

}
