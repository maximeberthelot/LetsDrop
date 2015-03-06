//
//  CreateMessageViewController.swift
//  LetsDrop
//
//  Created by Maxime Berthelot on 25/02/2015.
//  Copyright (c) 2015 Maxime Berthelot. All rights reserved.
//

import UIKit
import CoreData

class CreateMessageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var cancelBtn: DesignableButton!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var titleLabel: DesignableLabel!
    @IBOutlet weak var goToLifeTimeBtn: DesignableButton!
    
    //Action on click photo
    @IBAction func pickImage(sender: AnyObject) {
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        println("ko")
        self.dismissViewControllerAnimated(true, completion: nil)
        
        pickImage.image = image
    }
    
    
    @IBOutlet weak var pickImage: UIImageView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.messageField.delegate = self;
        // Set
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "Messages")
        request.returnsObjectsAsFaults = false
        var results:AnyObject = context.executeFetchRequest(request, error: nil)!
        var lenght = results.count
        
        titleLabel.text = results[lenght-1].title
        titleLabel.textColor = UIColor(hex: "#FFFFFF")
        
        if results[lenght-1].message != nil{
            messageField.text = results[lenght-1].message
        }
        println(results[lenght-1].title)
        println(results)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Delete all Message in localStorage and Purge Memory
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
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //Get Message
    func textFieldShouldReturn(messageField: UITextField!) -> Bool {
        self.view.endEditing(true);
        //Set in current Object
        var Data:String = messageField.text
        println(Data)
        var typeData:String = "message"
        setData(Data,typeData: typeData)

        return false;
    }
    
    // Set data in object/Entity Messages
    func setData(Data: String, typeData: String){
        println(Data+typeData)
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        //Adding part
        var request = NSFetchRequest(entityName: "Messages")
        request.returnsObjectsAsFaults = false
        var results:AnyObject = context.executeFetchRequest(request, error: nil)!
        var lenght = results.count
        
        
        results[lenght-1].setValue(Data, forKey: typeData)
        println(results[lenght-1])

    }
    //btn Interaction
    /********** ------ **/
    @IBAction func goToLifeTimeBtn(sender: AnyObject) {
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        //Adding part
        var request = NSFetchRequest(entityName: "Messages")
        request.returnsObjectsAsFaults = false
        var results:AnyObject = context.executeFetchRequest(request, error: nil)!
        var lenght = results.count
        
        println(results[lenght-1].message)
        
        if results[lenght-1].message == nil {
            var alert = UIAlertController(title: "Ops! Error", message: "Please, enter your message", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else{
            //GoToLifeTime View
            
            var nameStoryboard:String = "lifetimeStoryboard"
            var titleStoryboard:String = "lifetime"
            var storyboardID:String = "LifeTimeViewController"
            goToView(nameStoryboard,titleStoryboard: titleStoryboard,storyboardID: storyboardID)
        }
    }
    
    @IBAction func cancelBtn(sender: AnyObject) {
        
        //GoTo Navigation Storyboard
        var nameStoryboard:String = "navigationStoryboard",
            titleStoryboard:String = "navigation",
            storyboardID:String = "InitialViewController"
        goToView(nameStoryboard,titleStoryboard: titleStoryboard,storyboardID: storyboardID)
    }
    
    func goToView(nameStoryboard:String,titleStoryboard:String,storyboardID:String){
        var  nameStoryboard = UIStoryboard(name: titleStoryboard, bundle: nil)
        var controller = nameStoryboard.instantiateViewControllerWithIdentifier(storyboardID) as UIViewController
        controller.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        self.presentViewController(controller, animated: true, completion: nil)
    }
}