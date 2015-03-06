//
//  friendsListViewController.swift
//  LetsDrop
//
//  Created by Simon Corompt on 28/02/2015.
//  Copyright (c) 2015 Maxime Berthelot. All rights reserved.
//

import UIKit
import Foundation
import CoreData


class friendsListViewController: UIViewController, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    var friends = [NSManagedObject]()
    var sendTo = Array<String>()
    let service = "appAuth"
    let userAccount = "user"
    var loggedUserId = ""
    var alreadyFriend = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let (dic, errorLocksmith) = Locksmith.loadDataForUserAccount(userAccount)
        
        if dic != nil {
            
            if dic!["id"] != nil {
                self.loggedUserId = dic!["id"] as String!
                println("got id")
            }
        }

        
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"Friend")
        
        //3
        var error: NSError?
        
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest,
            error: &error) as [NSManagedObject]?
        
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
        let cellIdentifier = "CellFriend"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as CustomFriendTableViewCell
        
        let friend = friends[indexPath.row]
        var friendWithMeId = friend.valueForKey("user_id")? as String!
        var name = friend.valueForKey("login")? as String!
        
        println(name)
        cell.friendLabel.text = friend.valueForKey("login")? as String!
        
        var id = friend.valueForKey("id")? as String!
        println(id)
        
        var idInt = id.toInt()
        cell.addRemoveButton.tag = idInt!
        
        if friendWithMeId != nil {
            if friendWithMeId == self.loggedUserId {
                println("friend with me : \(name)")
                self.alreadyFriend.append(id)
                let image = UIImage(named: "icon-poubelle") as UIImage?
                cell.addRemoveButton.setImage(image, forState: .Normal)
                println(alreadyFriend)
            }
        }
        
        
        
        
        
        return cell
    }
    
    
    // MARK:- IBActions
    

    @IBAction func addFriendButton(sender: AnyObject) {
        
        var button:UIButton = sender as UIButton
        //use the tag to index the array
        var id = "\(button.tag)"
        
        if contains(self.alreadyFriend, id) {
            APIHelper.deleteFriend(id)
            
        } else if contains(self.sendTo, id) {
            // Remove user from friendlist
            self.sendTo = self.sendTo.filter({$0 != id})
            let image = UIImage(named: "icon-add") as UIImage?
            button.setImage(image, forState: .Normal)
            
        } else {
            // Add user in friendlist
            self.sendTo.append(id)
            button.frame = CGRectMake(0, 0, 100, 100)
            
            let image = UIImage(named: "icon-invite") as UIImage?
            button.setImage(image, forState: .Normal)
        }
        
        println(self.sendTo)
    }
    
    

}
