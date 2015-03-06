//
//  SettingsViewController.swift
//  LetsDrop
//
//  Created by Maxime Berthelot on 06/03/2015.
//  Copyright (c) 2015 Maxime Berthelot. All rights reserved.
//

import UIKIt

class SettingsViewContoller: UIViewController {
    
    var userAccount = "user"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let (dic, errorLocksmith) = Locksmith.loadDataForUserAccount(userAccount)
        
        if dic != nil {
            
            if dic!["id"] != nil {
                self.userAccount = dic!["id"] as String!
                println("User is logged")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}