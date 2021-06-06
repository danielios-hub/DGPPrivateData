//
//  Entry.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 23/5/21.
//

import UIKit

public struct Entry: Equatable {
    public var title: String
    var username: String
    var password: String
    var url: String
    var notes: String
    public var favorite: Bool
    let icon: String
    let id: String?
    var category: Category
    
    public init(category: Category) {
        self.init(title: "", username: nil, password: nil, url: nil, notes: nil, favorite: false, category: category)
    }
    
    init(title: String,
         username: String?,
         password: String?,
         url: String?,
         notes: String?,
         favorite: Bool,
         icon: String = "default_icon",
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
    
    public static func ==(lhs: Entry, rhs: Entry) -> Bool {
        return lhs.category == rhs.category &&
            rhs.title == lhs.title &&
        rhs.username == lhs.username &&
        rhs.password == lhs.password &&
        rhs.url == lhs.url &&
        rhs.notes == lhs.notes &&
        rhs.favorite == lhs.favorite &&
        rhs.icon == lhs.icon
    }
}
