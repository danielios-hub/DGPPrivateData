//
//  MainCoordinator.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 22/2/21.
//

import UIKit

class MainCoordinator: NSObject, Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = ListEntryVC.instantiate()
        let viewModel = ListEntryViewModel(dataSource: ManagerMasterCoreData.sharedInstance)
        vc.viewModel = viewModel
        vc.coordinator = self
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showAddEntry() {
        let child = AddEntryCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
        
        //normal push without an specific coordinator
//        let vc = AddEditVC.instantiate()
//        vc.coordinator = self
//        vc.viewModel = AddEntryViewModel(dataSource: ManagerMasterCoreData.sharedInstance)
//        navigationController.pushViewController(vc, animated: true)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}

extension MainCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        // Read the view controller we’re moving from.
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }


        // Check whether our view controller array already contains that view controller. If it does it means we’re pushing a different view controller on top rather than popping it, so exit.
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }

        // We’re still here – it means we’re popping the view controller, so we can check the class
        if let addEntryViewController = fromViewController as? AddEditVC {
            // We're popping a buy view controller; end its coordinator
            childDidFinish(addEntryViewController.coordinator)
            
            guard let toViewController = navigationController.transitionCoordinator?.viewController(forKey: .to) as? ListEntryVC else {
                return
            }
            
            toViewController.viewModel.initFetch()
            
        }
    }
}
