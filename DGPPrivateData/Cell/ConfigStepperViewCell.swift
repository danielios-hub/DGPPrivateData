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
        stepper.minimumValue = 0
        stepper.maximumValue = Double(PasswordManager.PasswordConfig.maximumCharacterForType)
        stepper.addTarget(self, action: #selector(stepperChange(_:)), for: .valueChanged)
    }
    
    @objc func stepperChange(_ sender: UIStepper) {
        let value = Int(sender.value)
        valueLabel.text = String(value)
        viewModel.value = value
    }
}
