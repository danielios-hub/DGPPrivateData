//
//  ListEntryPresenter.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 4/3/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ListEntryPresentationLogic {
    func presentInitialData(response: ListEntryScene.Load.Response)
}

class ListEntryPresenter: ListEntryPresentationLogic {
    weak var viewController: ListEntryDisplayLogic?
    
    // MARK: Do something
    
    func presentInitialData(response: ListEntryScene.Load.Response) {
        let cellsViewModel: [ListEntryCellViewModel] = response.entrys.map { model in
            let category = model.relationCategory?.name ?? ""
            return ListEntryCellViewModel(title: model.title, icon: model.icon, categoryDescription: category)
        }
        let viewModel = ListEntryScene.Load.ViewModel(cellsModel: cellsViewModel)
        viewController?.displayListEntrys(viewModel: viewModel)
    }
}
