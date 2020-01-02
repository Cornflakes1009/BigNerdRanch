//
//  ItemCell.swift
//  Homepwner
//
//  Created by HaroldDavidson on 12/29/19.
//  Copyright © 2019 HaroldDavidson. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var serialNumberLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    // gets called on an object after it is loaded from an archive (in this case it's the storyboard file)
    // actively updates the font size if the user changes the font size in settings
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.adjustsFontForContentSizeCategory = true
        serialNumberLabel.adjustsFontForContentSizeCategory = true
        valueLabel.adjustsFontForContentSizeCategory = true
    }
}
