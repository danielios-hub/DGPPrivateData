//
//  CollectionViewCellExtensions.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 13/3/21.
//

import UIKit

extension UICollectionView {
    
    func register(_ type: UICollectionViewCell.Type) {
        let className = String(describing: type)
        register(UINib(nibName: className, bundle: nil), forCellWithReuseIdentifier: className)
    }
    
    func dequeueCell<T>(_ type: T.Type, indexPath: IndexPath) -> T {
        let className = String(describing: type)
        return dequeueReusableCell(withReuseIdentifier: className, for: indexPath) as! T
    }
}

extension UICollectionViewCell {
    
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}
