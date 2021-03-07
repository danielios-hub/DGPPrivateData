//
//  AuthenticationRouter.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 5/3/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol AuthenticationRoutingLogic {
    func routeToListEntry()
}

protocol AuthenticationDataPassing {
    var dataStore: AuthenticationDataStore? { get }
}

class AuthenticationRouter: NSObject, AuthenticationRoutingLogic, AuthenticationDataPassing {
    weak var viewController: AuthenticationViewController?
    var dataStore: AuthenticationDataStore?
    
    // MARK: Routing
    
    func routeToListEntry() {
        let destinationVC = ListEntryViewController.instantiate()
        navigateToListEntry(source: viewController!, destination: destinationVC)
    }
    
    //func routeToSomewhere(segue: UIStoryboardSegue?)
    //{
    //  if let segue = segue {
    //    let destinationVC = segue.destination as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //  } else {
    //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //    navigateToSomewhere(source: viewController!, destination: destinationVC)
    //  }
    //}
    
    // MARK: Navigation
    
    func navigateToListEntry(source: AuthenticationViewController, destination: ListEntryViewController) {
      source.show(destination, sender: nil)
    }
    
    // MARK: Passing data
    
    //func passDataToSomewhere(source: AuthenticationDataStore, destination: inout SomewhereDataStore)
    //{
    //  destination.name = source.name
    //}
}
