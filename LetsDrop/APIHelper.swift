//
//  APIHelper.swift
//  LetsDrop
//
//  Created by Simon Corompt on 28/02/2015.
//  Copyright (c) 2015 Maxime Berthelot. All rights reserved.
//

import Foundation
import Alamofire
import CoreData
import UIKit

private let apiUrl:String = "http://macbook-simon.local/API/"
private let service = "appAuth"
private let userAccount = "user"

class APIHelper {
    
    class func getFriends() -> Void {
        println("getFriends")
        
        let (dic, error) = Locksmith.loadDataForUserAccount(userAccount)
        
        if dic != nil {
            
            var login = dic!["login"] as String
            var password = dic!["password"] as String
            var verb = "GET"
            var route = "me/friends"
            var url = apiUrl+route
            var signature = AuthHelper.getSignature(login, password: password, url: verb+":"+route)
            var mutableURLRequest = AuthHelper.buildRequest(url, login: login, signature: signature, parameters: nil, verb: "GET", auth: true)
            
            let manager = Alamofire.Manager.sharedInstance
            let request = manager.request(mutableURLRequest)
            request.responseJSON { (request, response, data, error) in

                if response!.statusCode == 200 {
                    
                    if data != nil {
                        var data = JSON(data!)
                        
                        var dataArray = data["data"].arrayValue
                        println(dataArray)
                        
                        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                        
                        let managedContext = appDelegate.managedObjectContext!
                        
                        let entity =  NSEntityDescription.entityForName("Friend", inManagedObjectContext: managedContext)
                        
                        
                        for (var i=0; i < dataArray.count; i++) {
                            let friend = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
                            
                            let id = dataArray[i]["user_id"].string!
                            let login = dataArray[i]["user"]["login"].string!
                            let phone = dataArray[i]["user"]["phone"].string!
                            let blocked = dataArray[i]["user"]["blocked"].string!
                            
                            friend.setValue(id, forKey: "id")
                            friend.setValue(login, forKey: "login")
                            friend.setValue(phone, forKey: "phone")
                            friend.setValue(blocked, forKey: "blocked")
                        }
                        
                        
                        var error: NSError?
                        if !managedContext.save(&error) {
                            println("Could not save \(error), \(error?.userInfo)")
                        }

                        
                    }
                    
                } else {
                    println("Request failed")
                }
            }
            
            
        } else {
            // User is not logged in
            
        }
        
        

        
        
    }
    
    
}