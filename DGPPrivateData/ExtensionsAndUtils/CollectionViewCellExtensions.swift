//
//  CollectionViewCellExtensions.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 13/3/21.
//

import UIKit

extension UICollectionViewCell {
    public static func getIdentifier() -> String {
        return String(describing: self)
    }
}
