//
//  AuthHelper.swift
//  LetsDrop
//
//  Created by Simon Corompt on 23/02/2015.
//  Copyright (c) 2015 Maxime Berthelot. All rights reserved.
//

import Foundation

class AuthHelper {
    
    
    
    class func getKey(username: String, password: String) -> String {
        let salt = "LoZ7ClfCbcUhsna0JjVsA9KZhj4hU9gT6HzGbnTpnZsSzJZxFuiK"
        var key = password.sha1()+"\(salt)"
        key = key.sha1()
        
        return key
    }
    
    class func getSignature(username: String, password: String, url:String) ->String {

        let key:String = self.getKey(username, password: password)
        
        let signature:String = url.hmac(HMACAlgorithm.SHA1, key:key)
        
        
        return signature
    }
    
    class func buildRequest(url: String,login: String, signature: String, parameters: String, verb: String, auth: Bool) -> NSMutableURLRequest {
        

        let URL = NSURL(string: url)
        var mutableURLRequest = NSMutableURLRequest(URL: URL!)

        mutableURLRequest.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        if auth == true {
            mutableURLRequest.setValue("\(login):\(signature)", forHTTPHeaderField: "X-Authorization")
        }

        
        switch verb {
        case "POST":
            
            mutableURLRequest.HTTPMethod = "POST"
            mutableURLRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
            mutableURLRequest.HTTPBody = parameters.dataUsingEncoding(NSUTF8StringEncoding)
        case "GET":

            mutableURLRequest.HTTPMethod = "GET"

        default:
            mutableURLRequest.HTTPMethod = "GET"
        }
        
        return mutableURLRequest
        
    }
}