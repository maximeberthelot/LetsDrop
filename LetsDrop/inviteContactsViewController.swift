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
import MessageUI

class inviteContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate {
    
    // MARK: - Properties
    
    let service = "appAuth"
    let userAccount = "user"
    var names = [String]()
    var phones = ""
    var login = ""
    var password = ""
    var signature = ""
    var addressBook: ABAddressBookRef?
    var contactList = Array<Dictionary<String, String>>()
    var usersList:JSON = ""
    @IBOutlet weak var tableView: UITableView!


    @IBAction func inviteButton(sender: UIButton) {
        
        var button:UIButton = sender as UIButton
        //use the tag to index the array
        
        var cellName:String = Array(self.contactList[button.tag].keys)[0]
        var phones:String = self.contactList[button.tag]["\(cellName)"]!
        println(phones)
        
        var messageVC = MFMessageComposeViewController()
        messageVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        messageVC.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        
        messageVC.body = "You should try Let's Drop app !";
        messageVC.recipients = ["\(phones)"]
        messageVC.messageComposeDelegate = self;
        
        self.presentViewController(messageVC, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60;
        self.accessAddressBook()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Tableview
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.names.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as CustomTableViewCell
        // Configure the cell...
        var name:String = Array(self.contactList[indexPath.row].keys)[0]
        var phones:String = self.contactList[indexPath.row]["\(name)"]!
        cell.nameLabel.text = name
        cell.phoneLabel.text = phones
        cell.inviteButton.tag = indexPath.row
        cell.addRemoveButton.tag = indexPath.row
        cell.addRemoveButton.enabled = false
        cell.addRemoveButton.hidden = true
        cell.inviteButton.hidden = false
        cell.inviteButton.enabled = true
        
        var (matched, id) = self.isRegistered(phones)
        if(matched){
            cell.inviteButton.hidden = true
            cell.inviteButton.enabled = false
            cell.addRemoveButton.hidden = false
            cell.addRemoveButton.enabled = true
            cell.phoneLabel.text = "TRUE"
            cell.idUser = "\(id)"
        }
        
        return cell
    }
    
    
    // MARK: - Addressbook
    
    func isRegistered(phones:String)->(Bool,Int) {
        var matched = false
        var id = 0
        var phonesArray = phones.componentsSeparatedByString(",")
        for phone in phonesArray {
            for(var i=0; i<self.usersList["data"].count; i++){
                
                if self.usersList["data"][i]["phone"].string == phone {
                    var match = self.usersList["data"][i]
                    println("match de :\(match)")
                    id = self.usersList["data"][i]["id"].int!
                    matched = true
                }
                
            }
        }
        
        
        return (matched, id)
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
            
            println("CONTACT")
            
            var contactPerson: ABRecordRef = record
            println("RECORD")
            var contactName:String = "TEST"
            if ABRecordCopyCompositeName(contactPerson) != nil {
                contactName = ABRecordCopyCompositeName(contactPerson).takeRetainedValue() as NSString
                
            }
            println ("contactName \(contactName)")
            self.names.append("\(contactName)")
            
            var emailArray:ABMultiValueRef = extractABEmailRef(ABRecordCopyValue(contactPerson, kABPersonPhoneProperty))!
                var phones = ""
            
            println("CONTACT OK")
            
            for (var j = 0; j < ABMultiValueGetCount(emailArray); ++j)
            {
                println("PHONES")
                var emailAdd = ABMultiValueCopyValueAtIndex(emailArray, j)
                var myString = extractABEmailAddress(emailAdd)

                myString = myString!.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil).stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil).stringByReplacingOccurrencesOfString("(", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil).stringByReplacingOccurrencesOfString(")", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil).stringByReplacingOccurrencesOfString("+33", withString: "0", options: NSStringCompareOptions.LiteralSearch, range: nil).stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil).stringByReplacingOccurrencesOfString("#", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                
                
                println("PHONES OK")
                    phones += "\(myString!),"
                println("email: \(myString)")
                self.phones += "\(myString!)%2C"
            }
            
            
            
            
            var contactDic = Dictionary<String, String>()
            contactDic["\(contactName)"] = "\(phones.removeCharsFromEnd(1))"
            self.contactList.append(contactDic)
            
        }
        
        self.phones = self.phones.removeCharsFromEnd(3)
        println(self.phones)
        println(self.contactList)
        
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
    
    // MARK: - Request
    
    func getFriends(phonesList: String) -> Void {
        
        var httpUrl = "GET:me/friends/suggest?phones="+self.phones
        // PAS DE CONTENT TYPE FORM EN REQUETE GET
        let (dic, error) = Locksmith.loadDataForUserAccount(self.userAccount)
        var data = JSON(dic!)
        println("data: \(data)")

        self.login = data["login"].string!
        self.password = data["password"].string!
        self.signature = AuthHelper.getSignature(self.login, password: self.password, url: httpUrl)
        
        println(AuthHelper.getKey("user", password: "user"))
        println(self.login)
        println("\(self.login) : \(self.password) : \(self.signature)")
        
        let url = "http://macbook-simon.local/API/PHP06/API/me/friends/suggest?phones="+self.phones
        
        println(url)
        var mutableURLRequest = AuthHelper.buildRequest(url, login: self.login, signature: self.signature, parameters: "", verb: "GET", auth:true)
        
        
        let manager = Alamofire.Manager.sharedInstance
        let request = manager.request(mutableURLRequest)
        request.responseJSON { (request, response, data, error) in
            println(data)
            println(response)
            if response!.statusCode == 200 {
            
            self.usersList = JSON(data!)
            println(self.usersList)
                
            self.tableView.reloadData()
            
            } else {
                println("Fail during process")
                println(data)
            }
        }
    }
    
    // MARK: - Message functions
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        switch (result.value) {
        case MessageComposeResultCancelled.value:
            println("Message was cancelled")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultFailed.value:
            println("Message failed")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultSent.value:
            println("Message was sent")
            self.dismissViewControllerAnimated(true, completion: nil)
        default:
            break;
        }
    }
    
    
    // Class end
}


//MARK:- Extensions

extension String {
    
    func removeCharsFromEnd(count:Int) -> String {
        let stringLength = countElements(self)
        
        let substringIndex = (stringLength < count) ? 0 : stringLength - count
        
        return self.substringToIndex(advance(self.startIndex, substringIndex))
    }
}

extension String {
    
    public func encodeURIComponent() -> String? {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
    }
}

extension String {
    func condenseWhitespace() -> String {
        let components = self.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).filter({!Swift.isEmpty($0)})
        return " ".join(components)
    }
}

