//
//  CustomTableViewCell.swift
//  LetsDrop
//
//  Created by Simon Corompt on 23/02/2015.
//  Copyright (c) 2015 Maxime Berthelot. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
