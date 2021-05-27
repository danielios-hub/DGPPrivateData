//
//  EntryMO+CoreDataClass.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 22/5/21.
//
//

import Foundation
import CoreData

@objc(EntryMO)
public class EntryMO: NSManagedObject {

}

extension EntryMO: DomainModel {
    typealias DomainModelType = Entry
    
    func toDomainModel() -> Entry {
        return Entry(from: self)
    }
}
