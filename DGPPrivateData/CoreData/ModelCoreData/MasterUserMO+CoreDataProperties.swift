//
//  MasterUserMO+CoreDataProperties.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 22/5/21.
//
//

import Foundation
import CoreData


extension MasterUserMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MasterUserMO> {
        return NSFetchRequest<MasterUserMO>(entityName: "MasterUserMO")
    }

    @NSManaged public var masterHash: String?

}

extension MasterUserMO : Identifiable {

}
