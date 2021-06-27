//
//  SceneDelegate.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 18/2/21.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        /*
        let authVC = AuthenticationViewController.instantiate()
        let navVC = UINavigationController(rootViewController: authVC)
    */
        
        let store = KeyChainStore()
        
        #if BETA
            //try? store.deleteAll()
        #endif
        
        let authenticationService = AuthenticationManager(
            store: store,
            passwordService: PasswordManager())

        let loginView = LoginView(authenticationService: authenticationService) { [weak window] in
            let destinationVC = ListEntryViewController.makeListEntryViewController()
            let navVC = UINavigationController(rootViewController: destinationVC)
            window?.rootViewController = navVC
        }
  
        let loginHostingView = UIHostingController(rootView: loginView)
        //let navVC = UINavigationController(rootViewController: loginView)
        
        window?.rootViewController = loginHostingView
        window?.makeKeyAndVisible()
    }

}

