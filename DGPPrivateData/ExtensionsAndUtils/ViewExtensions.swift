//
//  ViewExtensions.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 13/3/21.
//

import UIKit

extension UIView {
    func addSubviewForAutoLayout(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subview)
    }
    
    func fillConstraintsIn(parentView: UIView, leadingOffset: CGFloat = 0,
                           trailingOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) {
        NSLayoutConstraint.activate( [
            self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: leadingOffset),
            self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -trailingOffset),
            self.topAnchor.constraint(equalTo: parentView.topAnchor, constant: topOffset),
            self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -bottomOffset)
        ])
    }
    
    func centerIn(parentView: UIView) {
        NSLayoutConstraint.activate ( [
            self.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: parentView.centerYAnchor)
        ])
    }
}
