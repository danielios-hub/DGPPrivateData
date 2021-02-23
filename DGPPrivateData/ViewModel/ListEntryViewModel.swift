//
//  ListEntryViewModel.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 18/2/21.
//

import Foundation


public class ListEntryViewModel {
    
    let dataSource: MasterDataSource
    
    private var listCategory: [Category] = []
    private var listEntry: [Entry] = []
    
    private var cellViewModels: [ListEntryCellViewModel] = [] {
        didSet {
            reloadTableViewClosure?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    public var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var reloadTableViewClosure: (() -> Void)?
    var showAlertClosure: (() -> Void)?
    
    
    init(dataSource: MasterDataSource) {
        self.dataSource = dataSource
    }
    
    func initFetch() {
        listCategory = dataSource.getAllCategories()
        listEntry = dataSource.getAllEntrys()
        
        if !listEntry.isEmpty {
            var models : [ListEntryCellViewModel] = []
            listEntry.forEach {
                models.append(createCellViewModel(model: $0))
            }
            cellViewModels = models
        }
    }
    
    public func getCellViewModel(at indexPath: IndexPath) -> ListEntryCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    private func createCellViewModel(model: Entry) -> ListEntryCellViewModel {
        let category = model.relationCategory?.name ?? ""
        return ListEntryCellViewModel(title: model.title, icon: model.icon, categoryDescription: category)
    }
    
    
}

public struct ListEntryCellViewModel {
    public let title: String
    public let icon: String
    public let categoryDescription: String
}



