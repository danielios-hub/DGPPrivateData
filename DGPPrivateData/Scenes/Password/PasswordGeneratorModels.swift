//
//  PasswordGeneratorModels.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 8/3/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum PasswordGeneratorScene {
    // MARK: Use cases
    
    enum Show {
        struct Request {
        }
        struct Response {
            let password: String
        }
        struct ViewModel {
            let password: String
        }
    }
    
    enum New {
        struct Request {
            let config: PasswordManager.PasswordConfig
        }
        struct Response {
            let password: String
        }
        struct ViewModel {
            let password: String
        }
    }
    
    enum Copy {
        struct Request {
            let text: String
        }
        struct Response {
            
        }
        struct ViewModel {
            let message: String
        }
    }
    
    enum UpdateText {
        struct Request {
            let text: String
        }
    }
    
    //MARK: ViewModels
    
    class PasswordGeneratorViewModel {
        var config = PasswordManager.PasswordConfig()
        
        var numberOfRows: Int {
            return 4
        }
        
        lazy var cellsViewModels: [ConfigCellViewModel] = { return [
            ConfigCellViewModel(title: NSLocalizedString("a-z", comment: "Lowercase"), value: config.lowercaseCount),
            ConfigCellViewModel(title: NSLocalizedString("A-Z", comment: "Uppercase letters"), value: config.uppercaseCount),
            ConfigCellViewModel(title: NSLocalizedString("0-9", comment: "digits"), value: config.digitCount),
            ConfigCellViewModel(title: NSLocalizedString("Symbols", comment: "digits"), value: config.symbolCount)]
        }()
        
        enum Order: Int, CaseIterable {
            case total = 0
            case uppercase = 1
            case digit = 2
            case symbol = 3
        }
    }
    
    class ConfigCellViewModel {
        let title: String
        var value: Int
        
        init(title: String, value: Int) {
            self.title = title
            self.value = value
        }
    }
}