//
//  AboutUsDetailView.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 27/6/21.
//

import SwiftUI
import WebKit

struct AboutUsDetailView: View {
    
    var row: AboutUsRow
    @Environment(\.openURL) var openURL
    
    var body: some View {
        VStack(alignment: .center) {
            Text(row.title)
                .font(.title)
                .padding(.bottom, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            
            Text(row.description)
                .font(.headline)
            Spacer()
        }
        .padding()
        .onAppear() {
            if let url = row.url {
                openURL(url)
            }
        }
        
    }
}

struct AboutUsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let row = AboutUsRow(
            title: "Some Title",
            description: "some description of the row")
        AboutUsDetailView(row: row)
    }
}
