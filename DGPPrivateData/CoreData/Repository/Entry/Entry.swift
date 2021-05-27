//
//  Entry.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 23/5/21.
//

import UIKit

struct Entry {
    let title: String
    let username: String
    let password: String
    let url: String
    let notes: String
    let favorite: Bool
    let icon: String
    let category: Category
    
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

    }
    
    init(from entry: EntryMO) {
//        guard let category = entry.relationCategory else {
//            return nil
//        }
        self.category = Category(from: entry.relationCategory!)
        //self.category = Category(from: category)
        self.title = entry.title
        self.username = entry.username ?? ""
        self.password = entry.password ?? ""
        self.url = entry.url ?? ""
        self.notes = entry.notes ?? ""
        self.favorite = entry.favorite
        self.icon = entry.icon ?? ""
    }
}
