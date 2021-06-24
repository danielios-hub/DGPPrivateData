//
//  AddEditEntryPresenter.swift
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

protocol AddEditEntryPresentationLogic {
    func presentInitialData(response: AddEditEntryScene.Load.Response)
    func presentCreatedEntry(response: AddEditEntryScene.Save.Response)
    func presentSelectedCategory(response: AddEditEntryScene.UpdateCategory.Response)
    func presentCopySuccess(response: AddEditEntryScene.Copy.Response)
    func presentUpdatePassword(response: AddEditEntryScene.UpdatePassword.Response)
    func presentUpdateFavorite(response: AddEditEntryScene.UpdateFavorite.Response)
    func presentError(error: Error)
}

class AddEditEntryPresenter: AddEditEntryPresentationLogic {
    weak var viewController: AddEditEntryDisplayLogic?
    
    // MARK: Load Initial Data
    
    func presentInitialData(response: AddEditEntryScene.Load.Response) {
        let viewModel = AddEditEntryScene.Load.ViewModel(
            categories: response.categories,
            selectedIndex: response.selectedIndex,
            entry: response.entry)
        viewController?.displayInitialData(viewModel: viewModel)
    }
    
    func presentCreatedEntry(response: AddEditEntryScene.Save.Response) {
        viewController?.displayEntryCreated(viewModel: AddEditEntryScene.Save.ViewModel())
    }
    
    func presentSelectedCategory(response: AddEditEntryScene.UpdateCategory.Response) {
        let category = response.category
        let viewModel = AddEditEntryScene.UpdateCategory.ViewModel(categoryText: category.name, categoryIcon: category.icon)
        viewController?.displaySelectedCategory(viewModel: viewModel)
    }
    
    func presentUpdatePassword(response: AddEditEntryScene.UpdatePassword.Response){
        let viewModel = AddEditEntryScene.UpdatePassword.ViewModel(password: response.password)
        viewController?.displayUpdatePassword(viewModel: viewModel)
    }
    
    func presentUpdateFavorite(response: AddEditEntryScene.UpdateFavorite.Response) {
        let viewModel = AddEditEntryScene.UpdateFavorite.ViewModel(isFavorite: response.isfavorite)
        viewController?.displayUpdateFavorite(viewModel: viewModel)
    }
    
    func presentError(error: Error) {
        var descriptionError = NSLocalizedString("try_again", comment: "error message something went wrong")
        if let entryError = error as? AddEditEntryInteractor.EntryError {
            switch entryError {
            case .titleRequired(let message):
                descriptionError = message
            }
        }

        viewController?.displayError(viewModel: ErrorViewModel(msg: descriptionError))
    }
    
    func presentCopySuccess(response: AddEditEntryScene.Copy.Response) {
        let message = NSLocalizedString("Copy to clipboard", comment: "message when copy text to clipboard success")
        viewController?.displayToast(with: message)
    }
}
