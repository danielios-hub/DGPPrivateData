//
//  Category.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 22/5/21.
//

import Foundation

struct Category {
    let name: String
    let icon: String
    let id: String
    
    init(from category: CategoryMO) {
        self.name = category.name
        self.icon = category.icon
        self.id = category.objectID.uriRepresentation().absoluteString
    }
    
    init(name: String, icon: String) {
        self.name = name
        self.icon = icon
        self.id = ""
    }
}
