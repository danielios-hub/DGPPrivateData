//
//  ConfigSliderViewCell.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 8/3/21.
//

import UIKit

class ConfigSliderViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var slider: UISlider!
    
    var viewModel: PasswordGeneratorScene.ConfigCellViewModel! {
        didSet {
            titleLabel.text = viewModel.title
            valueLabel.text = "\(viewModel.value)"
            slider.setValue(Float(viewModel.value), animated: false)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        slider.minimumValue = 0
        slider.maximumValue = Float(PasswordConfig.maximumCharacterForType)
        slider.addTarget(self, action: #selector(updateValue(_:)), for: .valueChanged)
    }
    
    @objc func updateValue(_ sender: UISlider) {
        let value = UInt(sender.value)
        valueLabel.text = String(value)
        viewModel.value = value
    }
    
    
    
}
