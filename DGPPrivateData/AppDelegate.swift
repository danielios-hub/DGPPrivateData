//
//  AppDelegate.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 18/2/21.
//

import UIKit
import CoreData 

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

     var preferences: UserDefaultPreferencesService = UserDefaultPreferencesService(defaults: UserDefaults.standard)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

//MARK: - Factory methods

extension ListEntryViewController {
    
    static func makeListEntryViewController() -> ListEntryViewController {
        let viewController = ListEntryViewController.instantiate()
        let preferences = (UIApplication.shared.delegate as! AppDelegate).preferences
        let dataStore = viewController.router!.dataStore
        dataStore?.setDependencies(preferencesService: preferences,
                                   repositoryService: CoreDataRepositoryService.shared)
        
        return viewController
    }
}

