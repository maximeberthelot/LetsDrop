//
//  inviteContactsViewController.swift
//  LetsDrop
//
//  Created by Simon Corompt on 23/02/2015.
//  Copyright (c) 2015 Maxime Berthelot. All rights reserved.
//

import UIKit
import AddressBook
import Alamofire

class inviteContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let service = "appAuth"
    let userAccount = "user"
    var names = [String]()
    var phones = ""
    var login = ""
    var password = ""
    var signature = ""
    var addressBook: ABAddressBookRef?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80;
        self.accessAddressBook()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.names.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as CustomTableViewCell
        // Configure the cell...
        cell.nameLabel.text = names[indexPath.row]
        return cell
    }

    
    func extractABAddressBookRef(abRef: Unmanaged<ABAddressBookRef>!) -> ABAddressBookRef? {
        if let ab = abRef {
            return Unmanaged<NSObject>.fromOpaque(ab.toOpaque()).takeUnretainedValue()
        }
        
        return nil
    }
    
    func accessAddressBook() {
        if (ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.NotDetermined) {
            println("requesting access...")
            var errorRef: Unmanaged<CFError>? = nil
            addressBook = extractABAddressBookRef(ABAddressBookCreateWithOptions(nil, &errorRef))
                ABAddressBookRequestAccessWithCompletion(addressBook, { success, error in
                if success {
                    self.getContactNames()
                }
                else {
                    println("error")
                }
            })
        } else if (ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.Denied || ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.Restricted) {
        
            println("access denied")
        
        } else if (ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.Authorized) {
        
            println("access granted")
            self.getContactNames()
        }
    }
    
    func getContactNames() {
        var errorRef: Unmanaged<CFError>?
        addressBook = extractABAddressBookRef(ABAddressBookCreateWithOptions(nil, &errorRef))
        var contactList: NSArray = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue()
        println("records in the array \(contactList.count)")
            
        for record:ABRecordRef in contactList {
            var contactPerson: ABRecordRef = record
            var contactName: String = ABRecordCopyCompositeName(contactPerson).takeRetainedValue() as NSString
            println ("contactName \(contactName)")
            self.names.append("\(contactName)")
            
            
            var emailArray:ABMultiValueRef = extractABEmailRef(ABRecordCopyValue(contactPerson, kABPersonPhoneProperty))!
            
            for (var j = 0; j < ABMultiValueGetCount(emailArray); ++j)
            {
                var emailAdd = ABMultiValueCopyValueAtIndex(emailArray, j)
                var myString = extractABEmailAddress(emailAdd)

                myString = myString!.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil).stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil).stringByReplacingOccurrencesOfString("(", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil).stringByReplacingOccurrencesOfString(")", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                
                
                println("email: \(myString)")
                self.phones += "\(myString!),"
            }
        }
        
        self.phones = dropLast(self.phones)
        println(self.phones)
                
        self.getFriends(self.phones)
            
    }
    
    func extractABEmailRef (abEmailRef: Unmanaged<ABMultiValueRef>!) -> ABMultiValueRef? {
        if let ab = abEmailRef {
            return Unmanaged<NSObject>.fromOpaque(ab.toOpaque()).takeUnretainedValue()
        }
        return nil
    }
    
    func extractABEmailAddress (abEmailAddress: Unmanaged<AnyObject>!) -> String? {
        if let ab = abEmailAddress {
            return Unmanaged.fromOpaque(abEmailAddress.toOpaque()).takeUnretainedValue() as CFStringRef
        }
        return nil
    }
    
    
    
    func getFriends(phonesList: String) -> String {
        
        var postString = "login=user&password=user"
        
        var httpUrl = "POST:login"
        
        let (dic, error) = Locksmith.loadDataForUserAccount(userAccount)
        var data = JSON(dic!)
        self.login = data["login"].string!
        self.password = data["password"].string!
        self.signature = AuthHelper.getSignature(self.login, password: self.password, url: httpUrl)
        
        println(AuthHelper.getKey("user", password: "user"))
        println(self.login)
        println("\(self.login) : \(self.password) : \(self.signature)")
        
        let url = "http://localhost/API/PHP06/API/login"
        
        println(httpUrl)
        
        var mutableURLRequest = AuthHelper.buildRequest(url, login: self.login, signature: self.signature, parameters: postString, verb: "POST", auth:true)
        
        
        let manager = Alamofire.Manager.sharedInstance
        let request = manager.request(mutableURLRequest)
        request.responseJSON { (request, response, data, error) in
            debugPrintln(request)
            if response!.statusCode == 200 {
            
            // Sucessful signup
            
            let json = JSON(data!)
            let id = json["data"]["id"].int!
            println(id)
            
            } else {
                println("Fail during process")
                println(data)
            }
        }
        return "yo"
    }


}
