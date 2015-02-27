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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "Messages")
        request.returnsObjectsAsFaults = false
        var results:AnyObject = context.executeFetchRequest(request, error: nil)!
        var lenght = results.count
        
        println(results[lenght-1])
        
        var frame = CGRectMake(100, 100, 50, 50)
        var newView = DragViewController(frame: frame)
        newView.userInteractionEnabled = true
        newView.image = UIImage(named: "icon-drag")
        
        newView.contentMode = .ScaleAspectFit
        self.view.addSubview(newView)
        // theButton.titleLabel.text

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
    
    func setLabel(currentLife : String){
        println(currentLife)
    }
    
    @IBOutlet weak var lifeLabel: UILabel!
    class DragViewController: UIImageView {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
            println("coucou")
        }
        
        override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
            var touch: UITouch! = touches.anyObject() as UITouch!
            self.center = touch.locationInView(self.superview)
            
            println("coucouuuuuu")
            
        }
        
        override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
            var currentLife:String = "ououou"
            //lifeLabel.text = "ouou"
        }
        
    }
    
}