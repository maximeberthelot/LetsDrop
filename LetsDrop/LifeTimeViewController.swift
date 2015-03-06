//
//  ReceivedViewController.swift
//  LetsDrop
//
//  Created by Maxime Berthelot on 23/02/2015.
//  Copyright (c) 2015 Maxime Berthelot. All rights reserved.
//

import UIKit
import CoreData

class LifeTimeViewController: UIViewController {
    
    @IBOutlet weak var lifeLabel: UILabel!
    @IBOutlet weak var dragBtn: DesignableButton!
    @IBOutlet weak var goBack: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: "jumpToOtherTab:")
        leftSwipeGesture.direction = UISwipeGestureRecognizerDirection.Up
        view.addGestureRecognizer(leftSwipeGesture)
        
        var rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: "jumpToOtherTab:")
        rightSwipeGesture.direction = UISwipeGestureRecognizerDirection.Right
        view.addGestureRecognizer(rightSwipeGesture)
        
        var panGesture = UIPanGestureRecognizer(target: self, action: "moved:")
        dragBtn.addGestureRecognizer(panGesture)
        
        
       
     

    }
    
    func moved(gestureRecognizer: UIPanGestureRecognizer) -> Void {
        self.view.bringSubviewToFront(lifeLabel)
        var location = gestureRecognizer.locationInView(self.view)
        dragBtn.center = location
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds,
            screenHeight = screenSize.height,
            currentBtnY = dragBtn.frame.origin.y,
            myLifeTime = screenHeight/31,
            getMyLifetime = Int((currentBtnY/myLifeTime)+1)
        println("ok")
        println(Int(getMyLifetime))
        dragBtn.hidden = true
        lifeLabel.text = "\(String(getMyLifetime)) Day(s)"
        if gestureRecognizer.state == UIGestureRecognizerState.Ended{
            println("ko")
            dragBtn.hidden = false
            var validity: Int = getMyLifetime
            addTime(validity)
        }
        
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(sender: AnyObject) {
        //GoTo Navigation Storyboard
        var nameStoryboard:String = "createmessageStoryboard",
        titleStoryboard:String = "createmessage",
        storyboardID:String = "InitialCMessageViewController"
        goToView(nameStoryboard,titleStoryboard: titleStoryboard,storyboardID: storyboardID)
    }
    func goToView(nameStoryboard:String,titleStoryboard:String,storyboardID:String){
        var  nameStoryboard = UIStoryboard(name: titleStoryboard, bundle: nil)
        var controller = nameStoryboard.instantiateViewControllerWithIdentifier(storyboardID) as UIViewController
        controller.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
    
    func addTime(validity: Int){
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "Messages")
        request.returnsObjectsAsFaults = false
        var results:AnyObject = context.executeFetchRequest(request, error: nil)!
        var lenght = results.count
        //results[lenght-1].myligr

        results[lenght-1].setValue(validity, forKey: "validity")
       //results[lenght-1].validity = 12
        println(results[lenght-1].valueForKey("validity"))
        
        var error: NSError?
        if !context.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        
    }
    
    
}