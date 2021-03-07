//
//  AddEditEntryModels.swift
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

enum AddEditEntryScene {
    
    //MARK: - Entry info
    
    struct EntryFormFields {
        let title: String
        let username: String
        let password: String
        let notes: String
    }
    
    enum AddEditError: Error {
        case entityNotPresent
    }
    
    // MARK: Use cases
    
    // Load Data Request
    enum Load {
        
        struct Request {
        }
        struct Response {
            let categories: [Category]
        }
        struct ViewModel {
            
            let categories: [Category]
            var selectedIndex: Int
            
            var categoryText: String {
                return !categories.isEmpty ? categories[selectedIndex].name : ""
            }
            var categoryIcon: String {
                return !categories.isEmpty ? categories[selectedIndex].icon : ""
            }
            
            public mutating func updateSelectedIndex(_ index: Int) {
                selectedIndex = index
            }
            
            public func getSelectedCategory() -> Category? {
                return selectedIndex < categories.count ? categories[selectedIndex] : nil
            }
        }
    }
    
    // Save Entry
    enum Save {
        struct Request {
            var entryFormFields: EntryFormFields
        }
        struct Response {
            var entry: Entry?
        }
        struct ViewModel {
            
        }
    }
    
    //check if valif entry
    enum Valid {
        struct Request {
            let title: String
            let username: String
            let password: String
            let notes: String
        }
        struct Response {
            
        }
        struct ViewModel {
            
        }
    }
    
    enum Edit {
        struct Request {
            
        }
        struct Response {
            var entry: Entry
            
        }
        struct ViewModel {
            var entryFormFields: EntryFormFields
        }
    }
    
    enum UpdateCategory {
        struct Request {}
        struct Response {
            var category: Category
        }
        struct ViewModel {
            var categoryText: String
            var categoryIcon: String
        }
    }
    
}
