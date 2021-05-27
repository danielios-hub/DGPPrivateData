//
//  PasswordGeneratorComposer.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 21/5/21.
//

import Foundation

extension PasswordGeneratorViewController {
    
    static func makePasswordGenerator(initialPassword: String, delegate: PasswordGeneratorDelegate?) -> PasswordGeneratorViewController {
        let controller = PasswordGeneratorViewController.instantiate()
        var dataStore = controller.router!.dataStore!
        dataStore.password = initialPassword
        dataStore.delegate = delegate
        dataStore.passwordGenerator = PasswordManager.shared
        return controller
    }
    
}
