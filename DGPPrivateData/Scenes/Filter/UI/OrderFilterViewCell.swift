//
//  OrderFilterViewCell.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 30/5/21.
//

import UIKit

protocol OrderFilterViewCellDelegate: AnyObject {
    func orderFilterViewCellDelegateSaveOrderFilters(controller: OrderFilterViewCell)
}

class OrderFilterViewCell: UICollectionViewCell {
    
    var viewModel: FilterOptionViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            titleLabel.text = viewModel.title
            switchControl.isOn = viewModel.state
        }
    }
    
    weak var delegate: OrderFilterViewCellDelegate?
    
    var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var switchControl: UISwitch = {
        let control = UISwitch()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.isOn = false
        return control
    }()
    
    struct ViewTraits {
        static let heightSegmentedControl: CGFloat = 40
        static let padding: CGFloat = 16
        static let heightCell: CGFloat = 30
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.contentView.addSubview(switchControl)
        self.contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            switchControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            switchControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ViewTraits.padding),
            
            titleLabel.centerYAnchor.constraint(equalTo: switchControl.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: switchControl.trailingAnchor, constant: ViewTraits.padding)
        ])
        
        switchControl.addTarget(self, action: #selector(onValueChange(sender:)), for: .valueChanged)
    }
    
    @objc func onValueChange(sender: UISwitch) {
        viewModel?.state = sender.isOn
        viewModel?.updateClosure(sender.isOn)
        delegate?.orderFilterViewCellDelegateSaveOrderFilters(controller: self)
    }
    
 
    
    
    
}
