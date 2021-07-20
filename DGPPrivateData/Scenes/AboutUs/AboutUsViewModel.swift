//
//  AboutUsViewModel.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 27/6/21.
//

import Foundation

struct AboutUsSection: Identifiable {
    var id = UUID()
    var title: String
    var rows: [AboutUsRow]
}

struct AboutUsRow: Identifiable {
    var id = UUID()
    var title: String
    var description: String
    var url: URL? = nil
    var imageSystem: String?
}

struct AboutUsViewModel {
    let sections: [AboutUsSection]
    
    init() {
        let creditRows = [
            AboutUsRow(
                title: "Flaticon",
                description: "Icons made by Freepik from www.flaticon.com",
                url: URL(string: "https://www.flaticon.com"),
                imageSystem: nil)
        ]
        
        let privacyRows = [
            AboutUsRow(
                title: NSLocalizedString("Privacy", comment: "Privacy option text in menu"),
                description: NSLocalizedString("There is no recollection of data of any type. All data are keep in the device and there is no comunication with any service", comment: "Privacy policy"),
                imageSystem: "newspaper.fill")
        ]
        
        sections = [
            AboutUsSection(title: NSLocalizedString("Credits", comment: "Credits option text in menu"), rows: creditRows),
            AboutUsSection(title: NSLocalizedString("Privacy", comment: "Privacy option text in menu"), rows: privacyRows)
        ]
    }
}
