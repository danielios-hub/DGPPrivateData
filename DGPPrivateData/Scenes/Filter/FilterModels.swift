//
//  FilterModels.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 13/3/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum FilterScene {
    
    // MARK: Use cases
    
    enum Load {
        
        struct Request { }
        
        struct Response {
            let categoryFilters: [Filter]
            let orderFilters: [Filter]
        }
        
        struct ViewModel {
            var cellsCategoryModel: [FilterCellViewModel] = []
            var cellsOrderModel: [OrderCellViewModel] = []
            
            init(categoryFilters: [Filter], orderFilters: [Filter]) {
                cellsCategoryModel = categoryFilters.map { filter in
                    FilterCellViewModel(title: filter.title, icon: filter.icon, state: filter.state) { isSelected in
                        filter.state = isSelected
                    }
                }
                
                cellsOrderModel = orderFilters.map { filter in
                    OrderCellViewModel(title: filter.title, state: filter.state) { isSelected in
                        filter.state = isSelected
                    }
                }
            }
        }
    }
    
    enum ToggleFilter {
        struct Request {
            let index: Int
        }
    }
    
    enum OrderFilters {
        struct Request {}
    }
}
