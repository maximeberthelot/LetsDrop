//
//  CustomFriendSendTableViewCell.swift
//  LetsDrop
//
//  Created by Simon Corompt on 06/03/2015.
//  Copyright (c) 2015 Maxime Berthelot. All rights reserved.
//

import Foundation
import UIKit

class CustomFriendSendTableViewCell: UITableViewCell {
    

    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var addRemoveFriendButton: DesignableButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}