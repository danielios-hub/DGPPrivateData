//
//  Filter.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 30/5/21.
//

import Foundation

enum FilterType {
    case search(String)
    case order(Order)
    case categories([String])
}

class Filter: Codable {
    let title: String
    let icon: String
    var state: Bool
    
    init(title: String, icon: String, state: Bool) {
        self.title = title
        self.icon = icon
        self.state = state
    }
}
