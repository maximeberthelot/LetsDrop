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
        
        let salt = "LoZ7ClfCbcUhsna0JjVsA9KZhj4hU9gT6HzGbnTpnZsSzJZxFuiK"
        var login = usernameTextField.text
        var password = passwordTextField.text
        
        var key = password.sha1()+"\(salt)"
        key = key.sha1()
        
        var httpUrl = "POST:login"
        
        let signature:String = httpUrl.hmac(HMACAlgorithm.SHA1, key:key)
        
        println("key : \(key)")
        println("signature : \(signature)")
        
        let URL = NSURL(string:"http://localhost/API/PHP06/API/login")!
        
        var mutableURLRequest = NSMutableURLRequest(URL: URL)
        let postString = "login=\(login)&password=\(password)"
        
        mutableURLRequest.setValue("\(login):\(signature)", forHTTPHeaderField: "X-Authorization")
        mutableURLRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
        mutableURLRequest.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        mutableURLRequest.HTTPMethod = "POST"
        mutableURLRequest.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        
        let manager = Alamofire.Manager.sharedInstance
        let request = manager.request(mutableURLRequest)
        request.responseString { (request, response, string, error) in
            println(response!.statusCode)
            println(string)
            
            if response!.statusCode == 200 {
                println("Logged In !")
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