//
//  ConfigStepperViewCell.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 8/3/21.
//

import UIKit

class ConfigStepperViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var stepper: UIStepper!
    
    var viewModel: PasswordGeneratorScene.ConfigCellViewModel! {
        didSet {
            titleLabel.text = viewModel.title
            valueLabel.text = "\(viewModel.value)"
            stepper.value = Double(viewModel.value)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        stepper.neumorphism()
        stepper.minimumValue = 0
        stepper.maximumValue = Double(PasswordConfig.maximumCharacterForType)
        stepper.addTarget(self, action: #selector(stepperChange(_:)), for: .valueChanged)
        
        stepper.tintColor = .red
        
    }
    
    @objc func stepperChange(_ sender: UIStepper) {
        let value = UInt(sender.value)
        valueLabel.text = String(value)
        viewModel.value = value
    }
}
