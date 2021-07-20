//
//  AboutUsView.swift
//  DGPPrivateDataTests
//
//  Created by Daniel Gallego Peralta on 27/6/21.
//

import SwiftUI

struct AboutUsView: View {
    
    let viewModel = AboutUsViewModel()
    
    @Binding var showModal: Bool
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.sections) { section in
                    Section(
                        header: Text(section.title)
                            .frame(height: 50)
                    )
                    {
                        ForEach(section.rows) { row in
                            NavigationLink(
                                destination: AboutUsDetailView(row: row),
                                label: {
                                    AboutUsRowView(row: row)
                                }
                            )
                        }
                    }
                }
            }
            .navigationBarTitle(Text(NSLocalizedString("About Us",
                                                  comment: "About Us title page")),
                                displayMode: .inline
            )
            .toolbar(content: {
                Button(action: {
                    self.showModal = false
                }, label: {
                    Text(NSLocalizedString("Close", comment: "Close button title"))
                })
            })
        }
        .navigationBarColor(backgroundColor: UIColor.forgottenPurple!,
                            tintColor: .white)
        
    }
    
}

struct AboutUsRowView: View {
    var row: AboutUsRow
    
    var body: some View {
        HStack {
            if let image = row.imageSystem {
                Image(systemName: image)
            }
            Text(row.title)
        }
    }
}

struct AboutUsView_Previews: PreviewProvider {
    static var previews: some View {
        AboutUsView(showModal: .constant(true))
    }
}
