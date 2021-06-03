//
//  TableViewHelpers.swift
//  DGPPrivateDataTests
//
//  Created by Daniel Gallego Peralta on 30/5/21.
//

import UIKit

//MARK: - UITableView

extension UITableView {
    
    func cell(at row: Int, section: Int = 0) -> UITableViewCell? {
        let indexPath = IndexPath(row: row, section: section)
        return dataSource?.tableView(self, cellForRowAt: indexPath)
    }
    
    func select(row: Int, section: Int = 0) {
        let indexPath = IndexPath(row: row, section: section)
        selectRow(at: indexPath, animated: false, scrollPosition: .none)
        delegate?.tableView?(self, didSelectRowAt: indexPath)
    }
    
    func deselect(row: Int, section: Int = 0) {
        let indexPath = IndexPath(row: row, section: section)
        deselectRow(at: indexPath, animated: false)
        delegate?.tableView?(self, didDeselectRowAt: indexPath)
    }
    
}

//MARK:- UICollectionView

extension UICollectionView {
    
    func cell(at row: Int, section: Int = 0) -> UICollectionViewCell? {
        let indexPath = IndexPath(row: row, section: section)
        return dataSource?.collectionView(self, cellForItemAt: indexPath)
    }
    
    func select(row: Int, section: Int = 0) {
        let indexPath = IndexPath(row: row, section: section)
        selectItem(at: indexPath, animated: false, scrollPosition: .top)
        delegate?.collectionView?(self, didSelectItemAt: indexPath)
    }
    
    func deselect(row: Int, section: Int = 0) {
        let indexPath = IndexPath(row: row, section: section)
        deselectItem(at: indexPath, animated: false)
        delegate?.collectionView?(self, didDeselectItemAt: indexPath)
    }
}
