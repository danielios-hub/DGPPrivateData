//
//  Entry.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 23/5/21.
//

import UIKit

struct Entry {
    var title: String
    var username: String
    var password: String
    var url: String
    var notes: String
    var favorite: Bool
    let icon: String
    let id: String?
    var category: Category
    
    init(category: Category) {
        self.init(title: "", username: nil, password: nil, url: nil, notes: nil, favorite: false, category: category)
    }
    
    init(title: String,
         username: String?,
         password: String?,
         url: String?,
         notes: String?,
         favorite: Bool,
         icon: String = "",
         category: Category) {
        self.category = category
        self.title = title
        self.username = username ?? ""
        self.password = password ?? ""
        self.url = url ?? ""
        self.notes = notes ?? ""
        self.icon = icon
        self.favorite = favorite
        self.id = nil
    }
    
    init(from entry: EntryMO) {
        self.category = Category(from: entry.relationCategory!)
        self.title = entry.title
        self.username = entry.username ?? ""
        self.password = entry.password ?? ""
        self.url = entry.url ?? ""
        self.notes = entry.notes ?? ""
        self.favorite = entry.favorite
        self.icon = entry.icon ?? ""
        self.id = entry.objectID.uriRepresentation().absoluteString
    }
}
