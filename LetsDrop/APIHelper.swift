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
                            
                            let user_id = dataArray[i]["user_id"].string!
                            let id = dataArray[i]["user"]["id"].string!
                            let friend_with = dataArray[i]["friend_with"].string?
                            let login = dataArray[i]["user"]["login"].string!
                            let phone = dataArray[i]["user"]["phone"].string!
                            let blocked = dataArray[i]["user"]["blocked"].string!
                            
                            friend.setValue(user_id, forKey: "user_id")
                            friend.setValue(id, forKey: "id")
                            friend.setValue(friend_with, forKey: "friend_with")
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
    
    class func deleteFriend(id:String) -> Void {
        println("deleteFriend")
        
        let (dic, error) = Locksmith.loadDataForUserAccount(userAccount)
        
        if dic != nil {
            
            var login = dic!["login"] as String
            var password = dic!["password"] as String
            var verb = "DELETE"
            var route = "me/friends/"+"\(id)"
            var url = apiUrl+route
            var signature = AuthHelper.getSignature(login, password: password, url: verb+":"+route)
            var mutableURLRequest = AuthHelper.buildRequest(url, login: login, signature: signature, parameters: nil, verb: "DELETE", auth: true)
            
            let manager = Alamofire.Manager.sharedInstance
            let request = manager.request(mutableURLRequest)
            request.responseJSON { (request, response, data, error) in
                println(data)
                if response!.statusCode == 200 {
                    
                    println("deleted \(id)")
                    if data != nil {
                        var data = JSON(data!)
                        
                        var dataArray = data["data"].arrayValue
                        println("data:\(dataArray)")
                        
                        //1
                        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                        
                        let managedContext = appDelegate.managedObjectContext!
                        
                        //2
                        let fetchRequest = NSFetchRequest(entityName:"Friend")
                        fetchRequest.predicate = NSPredicate(format:"id == \(id)")
                        //3
                        var error: NSError?
                        
                        let fetchedResults = managedContext.executeFetchRequest(fetchRequest,
                            error: &error) as [NSManagedObject]?
                        

                        
                        if let results = fetchedResults {
                            let friend = results[0]
                            
                            
                            friend.setValue("", forKey:"user_id")
                            
                            var error: NSError?
                            if !managedContext.save(&error) {
                                println("Could not save \(error), \(error?.userInfo)")
                            } else {
                                println("done with success")
                            }
                            
                        } else {
                            println("Could not fetch \(error), \(error!.userInfo)")
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
    
    
    class func addFriend(id:String, loggedUserId:String) -> Void {
        println("addFriend")
        
        let (dic, error) = Locksmith.loadDataForUserAccount(userAccount)

        if dic != nil {
            
            var login = dic!["login"] as String
            var password = dic!["password"] as String
            var verb = "POST"
            var route = "me/friends"
            var url = apiUrl+route
            var signature = AuthHelper.getSignature(login, password: password, url: verb+":"+route)
            var postString = "friend_with=\(id)"
            var mutableURLRequest = AuthHelper.buildRequest(url, login: login, signature: signature, parameters: postString, verb: "POST", auth: true)
            
            let manager = Alamofire.Manager.sharedInstance
            let request = manager.request(mutableURLRequest)
            request.responseJSON { (request, response, data, error) in
                
                if response!.statusCode == 200 {
                    
                    if data != nil {
                        
                        
                        
                        var data = JSON(data!)
                        
                        var dataArray = data["data"].arrayValue
                        println(dataArray)
                        
                        //1
                        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                        
                        let managedContext = appDelegate.managedObjectContext!
                        
                        //2
                        let fetchRequest = NSFetchRequest(entityName:"Friend")
                        fetchRequest.predicate = NSPredicate(format:"id == \(id)")
                        //3
                        var error: NSError?
                        
                        let fetchedResults = managedContext.executeFetchRequest(fetchRequest,
                            error: &error) as [NSManagedObject]?
                        
                        
                        if let results = fetchedResults {
                            let friend = results[0]
                            
                            
                            friend.setValue(loggedUserId, forKey:"user_id")
                            
                            var error: NSError?
                            if !managedContext.save(&error) {
                                println("Could not save \(error), \(error?.userInfo)")
                            } else {
                                println("done with success")
                            }
                            
                        } else {
                            println("Could not fetch \(error), \(error!.userInfo)")
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
    
    class func sendPinTo(sendToArray:Array<String>, latitude:Double, longitude:Double, message: String, validity: Int, color:String) -> Void {
        
        let (dic, error) = Locksmith.loadDataForUserAccount(userAccount)

        if dic != nil {

            var login = dic!["login"] as String
            var password = dic!["password"] as String
            var verb = "POST"
            var route = "me/pins"
            println("fsf")
            println("\(sendToArray)")
            var toIds = ",".join(sendToArray)
            var postString = "latitude=\(latitude)&longitude=\(longitude)&message=\(message)&validity=\(validity)&color=\(color)&to_ids=\(toIds)"
            
            println("eki")
            
            var url = apiUrl+route
            var signature = AuthHelper.getSignature(login, password: password, url: verb+":"+route)
            var mutableURLRequest = AuthHelper.buildRequest(url, login: login, signature: signature, parameters: postString, verb: "POST", auth: true)
            
            println("eki")
            
            let manager = Alamofire.Manager.sharedInstance
            let request = manager.request(mutableURLRequest)
            request.responseJSON { (request, response, data, error) in
                println(data)
                if response!.statusCode == 200 {
                    
                    println("posted pin")
                    if data != nil {
                        var data = JSON(data!)
                        
                        var dataArray = data["data"].arrayValue
                        println("data:\(dataArray)")
                        
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