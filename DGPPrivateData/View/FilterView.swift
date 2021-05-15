//
//  FilterView.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 13/3/21.
//

import UIKit

class FilterView: UIView {
    
    //MARK: - Instance properties
    var collectionView: UICollectionView!
    
    struct ViewTraits {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
   
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FilterCellView.self, forCellWithReuseIdentifier: FilterCellView.getIdentifier())
      
        self.backgroundColor = .white
        self.collectionView.backgroundColor = .white
        self.collectionView.allowsMultipleSelection = true
        self.addSubviewForAutoLayout(collectionView)
    }
    
    func setupConstraints() {
        collectionView.fillConstraintsIn(parentView: self)
    }
    
    
}


