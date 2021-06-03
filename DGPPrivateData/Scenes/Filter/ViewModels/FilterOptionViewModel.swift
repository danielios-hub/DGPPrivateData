//
//  FilterOptionViewModel.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 30/5/21.
//

import Foundation

protocol FilterOptionViewModel {
    var title: String { get }
    var icon: String { get set }
    var state: Bool { get set }
    var updateClosure: ((Bool) -> Void) { get set }
}

extension FilterOptionViewModel {
    var icon: String {
        get {
            ""
        }
        set {}
    }
}

struct FilterCellViewModel: FilterOptionViewModel {
    var title: String
    var icon: String
    var state: Bool
    var updateClosure: ((Bool) -> Void)
}

struct OrderCellViewModel: FilterOptionViewModel {
    var title: String
    var state: Bool
    var updateClosure: ((Bool) -> Void)
}
