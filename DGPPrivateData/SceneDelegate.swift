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
        
        let store = KeyChainStore()
        let preferences = (UIApplication.shared.delegate as! AppDelegate).preferences
        
        preferences.executeOnFirstLaunch {
            try? store.deleteAll()
        }
        //try? store.deleteAll()
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
        
        window?.rootViewController = loginHostingView
        window?.makeKeyAndVisible()
    }
    

}

