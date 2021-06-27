//
//  DGPTextField.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 27/6/21.
//

import SwiftUI

///Custom Style
struct DGPTextField: TextFieldStyle {
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        return configuration
            .padding(EdgeInsets(top: 8,
                                leading: 16,
                                bottom: 8,
                                trailing: 16))
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 2)
                    .foregroundColor(Color(UIColor.forgottenPurple!))
            )
            .shadow(color: Color.gray.opacity(0.4),
                    radius: 3, x: 1, y: 2)
    }
}
