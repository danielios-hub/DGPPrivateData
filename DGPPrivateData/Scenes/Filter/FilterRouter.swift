//
//  FilterRouter.swift
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

@objc protocol FilterRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol FilterDataPassing {
    var dataStore: FilterDataStore? { get }
}

class FilterRouter: NSObject, FilterRoutingLogic, FilterDataPassing {
    weak var viewController: FilterViewController?
    var dataStore: FilterDataStore?
    
    // MARK: Routing
}
