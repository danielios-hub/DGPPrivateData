//
//  ManagerCoreDataStack.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 18/2/21.
//

import Foundation
import CoreData

open class CoreDataStack {
    
    public enum CoreDataError : Error {
        case saveContext(String)
    }
    
    public static let nameModel = "DGPPrivateModel"
    
    public static let managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: nameModel, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    public init() {}
    
    // MARK: - Core Data stack
    
    private lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: CoreDataStack.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("\(CoreDataStack.nameModel).sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType,
                                                configurationName: nil,
                                                at: url,
                                                options: [NSMigratePersistentStoresAutomaticallyOption: true,
                                                          NSInferMappingModelAutomaticallyOption: true,
                                                          NSPersistentStoreFileProtectionKey : FileProtectionType.complete])
        } catch var error1 as NSError {
            coordinator = nil
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error1
        } catch {

        }
        
        return coordinator
    }()

    
    open lazy var managedObjectContext: NSManagedObjectContext? = {
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    open lazy var managedPrivateObjectContext: NSManagedObjectContext? = {
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedPrivateObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedPrivateObjectContext.persistentStoreCoordinator = coordinator
        return managedPrivateObjectContext
    }()
    
}
