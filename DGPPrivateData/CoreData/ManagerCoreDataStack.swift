//
//  ManagerCoreDataStack.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 18/2/21.
//

import Foundation
import CoreData

public class ManagerCoreDataStack {
    
    public static var sharedInstance = ManagerCoreDataStack()
    
    private init() {}
    
    let nameModel = "DGPPrivateModel"
    
    public enum CoreDataError : Error {
        case saveContext(String)
    }
    
    // MARK: - Core Data stack
    
    private lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: nameModel, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("\(nameModel).sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: [NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true])
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

    public lazy var managedObjectContext: NSManagedObjectContext? = {
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    
    public lazy var managedPrivateObjectContext: NSManagedObjectContext? = {
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedPrivateObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedPrivateObjectContext.persistentStoreCoordinator = coordinator
        return managedPrivateObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    public func saveContext () throws {
        if let moc = self.managedObjectContext {
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let err as NSError {
                    let msg = "error saving main context \(err.localizedDescription) \(err.debugDescription)"
                    print(msg)
                    throw CoreDataError.saveContext(msg)
                    
                }
            }
        }
    }
    
    public func savePrivateContext() {
        if let moc = self.managedPrivateObjectContext, let _ = self.managedObjectContext {
            moc.perform { () -> Void in
                if moc.hasChanges{
                    do {
                        try moc.save()
                    }
                    catch let err as NSError{
                        print("error saving private context \(err.localizedDescription) \(err.debugDescription)")
                    }
                }
            }
        }
    }
}
