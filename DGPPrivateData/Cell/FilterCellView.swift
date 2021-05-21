//
//  FilterCellView.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 13/3/21.
//

import UIKit

class FilterCellView: UICollectionViewCell {
    
    //MARK: - Instance properties
    
    let iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    var viewModel: FilterCellViewModel! {
        didSet {
            titleLabel.text = viewModel.title
            iconImage.image = UIImage(named: "\(viewModel.icon)_big")
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.contentView.backgroundColor = isSelected ? .berry : UIColor.grayDark
            self.titleLabel.textColor = isSelected ? .white : .black
        }
    }
    
    struct ViewTraits {
        static let iconSize: CGFloat = 35
        static let topMargin: CGFloat = 10
        static let cellSize: CGSize = CGSize(width: 80, height: 80)
    }
    
    //MARK: - Life cicle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.addSubviewForAutoLayout(iconImage)
        contentView.addSubviewForAutoLayout(titleLabel)
        self.contentView.backgroundColor = .grayDark
        self.contentView.layer.cornerRadius = 8
        setupConstraint()
    }
    
    private func setupConstraint() {
        iconImage.centerIn(parentView: contentView)
        
        NSLayoutConstraint.activate( [
            iconImage.widthAnchor.constraint(equalToConstant: ViewTraits.iconSize),
            iconImage.heightAnchor.constraint(equalToConstant: ViewTraits.iconSize),
            iconImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -ViewTraits.topMargin),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}
