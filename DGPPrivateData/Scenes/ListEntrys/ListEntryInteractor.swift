//
//  ListEntryInteractor.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 4/3/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ListEntryBusinessLogic {
    func doLoadInitialData(request: ListEntryScene.Load.Request)
}

protocol ListEntryDataStore {
    var entries: [Entry] { get set }
}

class ListEntryInteractor: ListEntryBusinessLogic, ListEntryDataStore {
    var presenter: ListEntryPresentationLogic?
    
    var entries = [Entry]()
    var dataStore: StoreDataSource = UserDefaultManager()
    lazy var worker = ListEntryWorker(dataStore: dataStore)
    
    // MARK: Do something
    
    func doLoadInitialData(request: ListEntryScene.Load.Request) {
        worker.fetchEntrys(applyFilters: true) { entrys in
            self.entries = entrys
            let response = ListEntryScene.Load.Response(entrys: entrys)
            self.presenter?.presentInitialData(response: response)
        }
    }
}
