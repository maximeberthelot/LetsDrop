//
//  SendToViewController.swift
//  LetsDrop
//
//  Created by Simon Corompt on 06/03/2015.
//  Copyright (c) 2015 Maxime Berthelot. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SendToViewController: UIViewController,UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    

    var friends = [NSManagedObject]()
    var message = [NSManagedObject]()
    let service = "appAuth"
    let userAccount = "user"
    var loggedUserId = ""
    var sendTo = Array<String>()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 60;
        
        let (dic, errorLocksmith) = Locksmith.loadDataForUserAccount(userAccount)
        
        if dic != nil {
            
            if dic!["id"] != nil {
                self.loggedUserId = dic!["id"] as String!
                println("User is logged")
            }
        }
        
        
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"Friend")
        fetchRequest.predicate = NSPredicate(format:"user_id == \(loggedUserId)")
        
        let fetchMessages = NSFetchRequest(entityName:"Messages")

        //3
        var error: NSError?
        var errorMessages: NSError?
        
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest,
            error: &error) as [NSManagedObject]?
        
        let fetchedResultsMessages = managedContext.executeFetchRequest(fetchMessages,
            error: &errorMessages) as [NSManagedObject]?
        
        if let resultsMessages = fetchedResultsMessages {
            message = resultsMessages
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
        if let results = fetchedResults {
            friends = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            
        return friends.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "CellFriendSend"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as CustomFriendSendTableViewCell
        
        let friend = friends[indexPath.row]
        var name = friend.valueForKey("login")? as String!
        
        cell.friendNameLabel.text = friend.valueForKey("login")? as String!
        
        var id = friend.valueForKey("id")? as String!
        
        var idInt = id.toInt()
        cell.addRemoveFriendButton.tag = idInt!
        
        return cell
    }
    
    @IBAction func addRemoveButton(sender: AnyObject) {
        var button:UIButton = sender as UIButton
        //use the tag to index the array
        var id = "\(button.tag)"
        
        if contains(self.sendTo, id) {
            self.sendTo = self.sendTo.filter({$0 != id})
            
            let image = UIImage(named: "icon-add") as UIImage?
            button.setImage(image, forState: .Normal)

            
        } else {
            // Add user in friendlist
            self.sendTo.append(id)

            let image = UIImage(named: "icon-poubelle") as UIImage?
            button.setImage(image, forState: .Normal)
            

        }
        
        println("\(self.sendTo)")


    }
    
    func deleteMessages(){
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate,
        context: NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "Messages")
        request.returnsObjectsAsFaults = false
        var results:AnyObject = context.executeFetchRequest(request, error: nil)!,
        lenght = results.count
        
        for var i = 0; i<lenght; i++ {
            context.deleteObject(results[i] as NSManagedObject)
            context.save(nil)
        }
    }

    
    @IBAction func dismissViewController(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func sendPin(sender: AnyObject) {
        var latitude = message[message.count-1].valueForKey("latitude") as Double!
        var longitude = message[message.count-1].valueForKey("longitude") as Double!
        var messageText = message[message.count-1].valueForKey("message") as String!
        println("\(messageText)")
        var validity = message[message.count-1].valueForKey("validity") as Int
        var color = "blue"
        
        APIHelper.sendPinTo(self.sendTo, latitude:latitude, longitude:longitude, message: messageText, validity: validity, color: color)
        
        deleteMessages()
        println(message)
        
        
    }

}