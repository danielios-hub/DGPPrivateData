//
//  DomainModel.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 22/5/21.
//

import Foundation

protocol DomainModel {
    associatedtype DomainModelType
    func toDomainModel() -> DomainModelType
}
