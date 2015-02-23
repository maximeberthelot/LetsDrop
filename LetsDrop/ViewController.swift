//
//  ViewController.swift
//  LetsDrop
//
//  Created by Maxime Berthelot on 22/02/2015.
//  Copyright (c) 2015 Maxime Berthelot. All rights reserved.
//

import UIKit

class ViewViewController: UIViewController {
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signInButton(sender: AnyObject) {
        
        // Load loginStoryboard and present it
        var loginStoryboard = UIStoryboard(name: "login", bundle: nil)
        var controller = loginStoryboard.instantiateViewControllerWithIdentifier("InitialViewController") as UIViewController
        controller.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
    @IBAction func SignUpButton(sender: AnyObject) {
        
        
    }


}

