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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: "jumpToOtherTab:")
        leftSwipeGesture.direction = UISwipeGestureRecognizerDirection.Left
        view.addGestureRecognizer(leftSwipeGesture)
        
        var rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: "jumpToOtherTab:")
        rightSwipeGesture.direction = UISwipeGestureRecognizerDirection.Right
        view.addGestureRecognizer(rightSwipeGesture)
        
        var panGesture = UIPanGestureRecognizer(target: self, action: "moveViewWithGestureRecognizer:")
        dragBtn.addGestureRecognizer(panGesture)
        
        
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "Messages")
        request.returnsObjectsAsFaults = false
        var results:AnyObject = context.executeFetchRequest(request, error: nil)!
        var lenght = results.count
        
        println(results[lenght-1])
     

    }
    
    func moveViewWithGestureRecognizer(gestureRecognizer: UIPanGestureRecognizer) -> Void {
        self.view.bringSubviewToFront(lifeLabel)
        var location = gestureRecognizer.locationInView(self.view)
        dragBtn.center = location
        
        println("coucou ")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToView(nameStoryboard:String,titleStoryboard:String,storyboardID:String){
        var  nameStoryboard = UIStoryboard(name: titleStoryboard, bundle: nil)
        var controller = nameStoryboard.instantiateViewControllerWithIdentifier(storyboardID) as UIViewController
        controller.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
    
    
    
    
}