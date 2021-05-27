//
//  CategoryMO+CoreDataClass.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 22/5/21.
//
//

import Foundation
import CoreData

@objc(CategoryMO)
public class CategoryMO: NSManagedObject {

}

extension CategoryMO: DomainModel {
    typealias DomainModelType = Category
    
    func toDomainModel() -> Category {
        return Category(from: self)
    }
}
