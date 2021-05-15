//
//  UserDefaultsManager.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 14/5/21.
//

import Foundation

protocol StoreDataSource {
    var filterList: [Filter] { get set }
}

class UserDefaultManager: StoreDataSource {
    
    let encoder: JSONEncoder
    let decoder: JSONDecoder
    
    init() {
        encoder = JSONEncoder()
        decoder = JSONDecoder()
    }
    
    struct Constants {
        static let filterList = "filterList"
    }
    
    var filterList: [Filter] {
        get {
            if let data = UserDefaults.standard.data(forKey: Constants.filterList),
               let objectList = try? decoder.decode([Filter].self, from: data) {
                return objectList
            }
            return []
        }
        set {
            if let data = try? encoder.encode(newValue) {
                UserDefaults.standard.set(data, forKey: Constants.filterList)
            }
        }
    }
}
