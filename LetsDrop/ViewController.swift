//
//  ViewController.swift
//  LetsDrop
//
//  Created by Maxime Berthelot on 22/02/2015.
//  Copyright (c) 2015 Maxime Berthelot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let service = "appAuth"
    let userAccount = "user"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        // Checking if userdata is already stored in Keychain
        Locksmith.deleteDataForUserAccount(userAccount)
        let (dic, error) = Locksmith.loadDataForUserAccount(userAccount)
        
        if dic != nil {
            
            if dic!["id"] != nil {
                
                // user is already logged in
                // Loading app
                var loginStoryboard = UIStoryboard(name: "navigation", bundle: nil)
                var controller = loginStoryboard.instantiateViewControllerWithIdentifier("InitialViewController") as UIViewController
                controller.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
                self.presentViewController(controller, animated: true, completion: nil)
                
            }
        } else {
            
            println("not logged")
            
        }

    }
    
    
    @IBAction func signInButton(sender: AnyObject) {
        
        // Load loginStoryboard and present it
        var loginStoryboard = UIStoryboard(name: "login", bundle: nil)
        var controller = loginStoryboard.instantiateViewControllerWithIdentifier("InitialViewController") as UIViewController
        controller.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func signUpButton(sender: AnyObject) {
        // Load loginStoryboard and present it
        var signUpStoryboard = UIStoryboard(name: "signUp", bundle: nil)
        var controller = signUpStoryboard.instantiateViewControllerWithIdentifier("InitialViewController") as UIViewController
        controller.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        self.presentViewController(controller, animated: true, completion: nil)
        
        
    }
    
}

