//
//  UserDefaultsManager.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 14/5/21.
//

import Foundation

protocol PreferencesService {
    var filterList: [Filter] { get set }
    var orderList: [Filter] { get set }
    var isGroupedByCategories: Bool { get }
}

class UserDefaultPreferencesService: PreferencesService {
    
    let encoder: JSONEncoder
    let decoder: JSONDecoder
    
    init() {
        encoder = JSONEncoder()
        decoder = JSONDecoder()
    }
    
    struct Constants {
        static let filters = "filterList"
        static let orders = "orderList"
    }
    
    var filterList: [Filter] {
        get {
            if let data = UserDefaults.standard.data(forKey: Constants.filters),
               let objectList = try? decoder.decode([Filter].self, from: data) {
                return objectList
            }
            return []
        }
        set {
            if let data = try? encoder.encode(newValue) {
                UserDefaults.standard.set(data, forKey: Constants.filters)
            }
        }
    }
    
    var orderList: [Filter] {
        get {
            if let data = UserDefaults.standard.data(forKey: Constants.orders),
               let objectList = try? decoder.decode([Filter].self, from: data) {
                return objectList
            }
            return []
        }
        set {
            if let data = try? encoder.encode(newValue) {
                UserDefaults.standard.set(data, forKey: Constants.orders)
            }
        }
    }
    
    public var isGroupedByCategories: Bool {
        return orderList.filter {
            $0.title == Filter.groupByCategories
            
        }.first?.state ?? false
    }
}
