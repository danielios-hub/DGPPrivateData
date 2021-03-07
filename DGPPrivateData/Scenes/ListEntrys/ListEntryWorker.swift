//
//  ListEntryWorker.swift
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

class ListEntryWorker {
    func fetchEntrys(completionHandler: ([Entry]) -> Void ) {
        ManagerMasterCoreData.sharedInstance.getAllEntrys { entrys in
            completionHandler(entrys)
        }
    }
}
