//
//  AddEntryCoordinator.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 22/2/21.
//

import UIKit

class AddEntryCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    public weak var parentCoordinator: MainCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = AddEditVC.instantiate()
        vc.coordinator = self
        vc.viewModel = AddEntryViewModel(dataSource: ManagerMasterCoreData.sharedInstance)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }
}
