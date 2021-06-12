//
//  Filter.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 30/5/21.
//

import Foundation

public enum FilterType {
    case search(String)
    case order(Order)
    case categories([String])
    case isFavorite(Bool)
}

public class Filter: Codable {
    let title: String
    let icon: String
    var state: Bool
    
    public static var favoriteFilterName = "Favorites"
    public static var favoriteFilterIcon = "default_icon"
    
    public static var alphabetically = "Alphabetically"
    public static var groupByCategories = "Group by Categories"
    
    init(title: String, icon: String, state: Bool) {
        self.title = title
        self.icon = icon
        self.state = state
    }
}
