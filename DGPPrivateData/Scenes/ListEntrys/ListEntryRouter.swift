//
//  ListEntryRouter.swift
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

@objc protocol ListEntryRoutingLogic {
    func routeToAddEntry()
    func routeToEditEntry()
    func routeToFilters()
}

protocol ListEntryDataPassing {
    var dataStore: ListEntryDataStore? { get }
}

class ListEntryRouter: NSObject, ListEntryRoutingLogic, ListEntryDataPassing {
    weak var viewController: ListEntryViewController?
    var dataStore: ListEntryDataStore?
    
    // MARK: Routing
    
    func routeToAddEntry() {
        let destinationVC = AddEditEntryViewController.instantiate()
        navigateToAddEntry(source: viewController!, destination: destinationVC)
        
    }
    
    func routeToEditEntry() {
        let destinationVC = AddEditEntryViewController.instantiate()
        var destinationDS = destinationVC.router!.dataStore!
        passDataToEdit(source: dataStore!, destination: &destinationDS)
        navigateToAddEntry(source: viewController!, destination: destinationVC)
    }
    
    func routeToFilters() {
        let destinationVC = FilterViewController()
        navigateToFilters(source: viewController!, destination: destinationVC)
    }
    
    // MARK: Navigation
    
    func navigateToAddEntry(source: ListEntryViewController, destination: AddEditEntryViewController) {
        source.show(destination, sender: nil)
    }
    
    func navigateToFilters(source: ListEntryViewController, destination: FilterViewController) {
        source.show(destination, sender: nil)
    }
    
    //MARK: Passing data
    
    func passDataToEdit(source: ListEntryDataStore, destination: inout AddEditEntryDataStore) {
        let selectedIndex = viewController!.selectedRow
        destination.entry = source.entries[selectedIndex!]
    }
}
