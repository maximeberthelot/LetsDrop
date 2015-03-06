//
//  LoginViewController.swift
//  LetsDrop
//
//  Created by Simon Corompt on 22/02/2015.
//  Copyright (c) 2015 Maxime Berthelot. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    let service = "appAuth"
    let userAccount = "user"
    let key = "id"
    
    @IBOutlet weak var logView: DesignableView!
    @IBOutlet weak var passView: DesignableView!
    @IBOutlet weak var usernameTextField: DesignableTextField!
    @IBOutlet weak var passwordTextField: DesignableTextField!
    @IBOutlet weak var errorLabel: DesignableLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set animation for the input field
        logView.animation = "zoomIn"
        logView.delay = 1
        
        // Set animation for the transition to password input
        passView.animation = "zoomIn"
        passView.delay = 0.1
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        usernameTextField.becomeFirstResponder()
        logView.animate()
        
        // Set animation out for transition to password input
        
        logView.animation = "fadeOut"
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func goToPassword(sender: AnyObject) {
        
        logView.animate()
        passView.animate()
        
        passwordTextField.becomeFirstResponder()
        
    }
    
    
    @IBAction func signIn(sender: AnyObject) {
        
        var login = usernameTextField.text
        var password = passwordTextField.text
        
        var httpUrl = "POST:login"
        
        var signature = AuthHelper.getSignature(login, password: password, url: httpUrl)
        
        let postString = "login=\(login)&password=\(password)"
        
        var mutableURLRequest = AuthHelper.buildRequest("http://macbook-simon.local/API/login", login: login, signature: signature, parameters: postString, verb: "POST", auth: true)
        
        let manager = Alamofire.Manager.sharedInstance
        let request = manager.request(mutableURLRequest)
        request.responseJSON { (request, response, data, error) in
            println(data)
            if response!.statusCode == 200 {
                // Sucessful signup
                
                let json = JSON(data!)
                let id = json["data"]["id"].int!
                println(json)
                
                let error = Locksmith.saveData(["id": "\(id)", "login": login, "password": password], forUserAccount: self.userAccount)
                
                var navStoryboard = UIStoryboard(name: "navigation", bundle: nil)
                var navController = navStoryboard.instantiateViewControllerWithIdentifier("InitialViewController") as UIViewController
                navController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
                navController.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
                
                APIHelper.getFriends()
                
                self.presentViewController(navController, animated: true, completion: nil)
                
                
            } else {
                
                self.usernameTextField.becomeFirstResponder()
                
                self.errorLabel.animation = "fadeIn"
                self.errorLabel.animate()
                self.errorLabel.text = "Wrong login or password"
                self.passwordTextField.text = ""
                self.usernameTextField.text = ""
                
                self.passView.animation = "shake"
                self.passView.animate()
                
                // Reset view to username
                
                self.errorLabel.animation = "fadeOut"
                
                self.passView.animation = "fadeOut"
                self.passView.delay = 0.5
                self.passView.animate()
                self.logView.animation = "zoomIn"
                self.logView.delay = 0.8
                self.logView.animate()
                self.errorLabel.delay = 2
                self.errorLabel.animate()
                
                // Reset animation to base state
                
                // Set animation for the input field
                self.logView.animation = "fadeOut"
                
                
                // Set animation for the transition to password input
                
                self.passView.animation = "zoomIn"
                self.passView.delay = 0.1
                
                
            }
        }
    }
    
}