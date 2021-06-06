//
//  Category.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 22/5/21.
//

import Foundation

public struct Category: Equatable {
    public let name: String
    public let icon: String
    public let id: String
    
    init(from category: CategoryMO) {
        self.name = category.name
        self.icon = category.icon
        self.id = category.objectID.uriRepresentation().absoluteString
    }
    
    public init(name: String, icon: String) {
        self.name = name
        self.icon = icon
        self.id = ""
    }
    
    public static func ==(lhs: Category, rhs: Category) -> Bool {
        return lhs.name == rhs.name && rhs.icon == lhs.icon
    }
}
