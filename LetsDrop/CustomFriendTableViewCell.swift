//
//  CustomFriendTableViewCell.swift
//  LetsDrop
//
//  Created by Simon Corompt on 01/03/2015.
//  Copyright (c) 2015 Maxime Berthelot. All rights reserved.
//

import UIKit

class CustomFriendTableViewCell: UITableViewCell {
    
    
    
    
    @IBOutlet weak var friendLabel: UILabel!
    @IBOutlet weak var addRemoveButton: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}