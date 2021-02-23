//
//  Coordinator.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 22/2/21.
//

import UIKit 

public protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}
