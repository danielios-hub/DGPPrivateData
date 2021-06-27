//
//  DGPButtonModifier.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 27/6/21.
//

import SwiftUI

struct DGPButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .padding()
            .background(Color(UIColor.forgottenPurple!))
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}

extension View {
    func dgpButton() -> some View {
        ModifiedContent(
            content: self,
            modifier: DGPButtonModifier()
        )
    }
}
