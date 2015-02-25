//
//  SignUpViewController.swift
//  LetsDrop
//
//  Created by Simon Corompt on 23/02/2015.
//  Copyright (c) 2015 Maxime Berthelot. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class SignUpViewController: UIViewController {
    
    let service = "appAuth"
    let userAccount = "user"
    let key = "id"
    
    @IBOutlet weak var logView: DesignableView!
    @IBOutlet weak var passView: DesignableView!
    @IBOutlet weak var phoneView: DesignableView!
    
    @IBOutlet weak var passwordTextField: DesignableTextField!
    @IBOutlet weak var usernameTextField: DesignableTextField!
    @IBOutlet weak var phoneTextField: DesignableTextField!
    
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
        
        passView.animation = "fadeOut"
        phoneView.animation = "zoomIn"
        
        passwordTextField.becomeFirstResponder()
    }

    @IBAction func goToPhone(sender: AnyObject) {
        
        passView.animate()
        phoneView.animate()
        phoneTextField.becomeFirstResponder()
        
    }
    
    
    @IBAction func SignUp(sender: AnyObject) {
        
        var login = usernameTextField.text
        var password = passwordTextField.text
        var phone = phoneTextField.text
        
        var httpUrl = "POST:signup"
        
        let url = "http://macbook-simon.local/API/PHP06/API/signup"
        
        let postString = "login=\(login)&password=\(password)&phone=\(phone)"
        
        var mutableURLRequest = AuthHelper.buildRequest(url, login: login, signature: "nil", parameters: postString, verb: "POST", auth:false)

        
        let manager = Alamofire.Manager.sharedInstance
        let request = manager.request(mutableURLRequest)
        request.responseJSON { (request, response, data, error) in
            
            if response!.statusCode == 200 {
                
                // Sucessful signup
                
                let json = JSON(data!)
                let id = json["data"]["id"].int!
                println(id)
                
                let error = Locksmith.saveData(["id": "\(id)", "login": login, "password":password], forUserAccount: self.userAccount)
                if error == nil {
                    
                    // Loading contact invitation manager
                    var loginStoryboard = UIStoryboard(name: "inviteContacts", bundle: nil)
                    var controller = loginStoryboard.instantiateViewControllerWithIdentifier("InitialViewController") as UIViewController
                    controller.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
                    self.presentViewController(controller, animated: true, completion: nil)
                }
            
            } else {
                println("Fail during process")
                println(data)
            }
        }
        

    }
    

}
