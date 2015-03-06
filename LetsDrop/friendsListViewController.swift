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
        
        var idInt = id.toInt()
        cell.addRemoveButton.tag = idInt!
        
        if friendWithMeId != nil {
            if friendWithMeId == self.loggedUserId {
                self.alreadyFriend.append(id)
                let image = UIImage(named: "icon-poubelle") as UIImage?
                cell.addRemoveButton.setImage(image, forState: .Normal)
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
            self.alreadyFriend = self.alreadyFriend.filter({$0 != id})
            println("friend removed: \(self.alreadyFriend)")
            
            let image = UIImage(named: "icon-add") as UIImage?
            button.setImage(image, forState: .Normal)
            APIHelper.deleteFriend(id)

            // FIX RELOAD TABLE VIEW
            
        } else {
            // Add user in friendlist
            self.alreadyFriend.append(id)
            println("friend added: \(self.alreadyFriend)")
            let image = UIImage(named: "icon-poubelle") as UIImage?
            button.setImage(image, forState: .Normal)
            
            APIHelper.addFriend(id, loggedUserId: self.loggedUserId)

        }
        
        println(self.alreadyFriend)
    }
    
    

}
