//
//  ListEntryViewCell.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 18/2/21.
//

import UIKit

public class ListEntryViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var iconView: UIImageView!
    @IBOutlet var titleCategory: UILabel!
    
    var viewModel: ListEntryCellViewModel? {
        didSet {
            titleLabel.text = viewModel?.title
            titleCategory.text = viewModel?.categoryDescription
            
            if let icon = viewModel?.icon {
                iconView.image = UIImage(named: icon)
            }
        }
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
