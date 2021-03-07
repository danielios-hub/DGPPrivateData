//
//  SceneDelegate.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 18/2/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        let authVC = AuthenticationViewController.instantiate()
        let navVC = UINavigationController(rootViewController: authVC)
        
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
    }

}

