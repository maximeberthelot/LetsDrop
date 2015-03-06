//
//  CreateMessageViewController.swift
//  LetsDrop
//
//  Created by Maxime Berthelot on 25/02/2015.
//  Copyright (c) 2015 Maxime Berthelot. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices
import Photos
import AVKit

class CreateMessageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var photoSelected:Bool = false
    
    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var cancelBtn: DesignableButton!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var titleLabel: DesignableLabel!
    @IBOutlet weak var goToLifeTimeBtn: DesignableButton!

    func currentStatus() -> Bool {
        // access permission dialog will appear automatically if necessary...
        // ...when we try to present the UIImagePickerController
        // however, things then proceed asynchronously
        // so it can look better to try to ascertain permission in advance
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .Authorized:
            return true
        case .NotDetermined:
            PHPhotoLibrary.requestAuthorization(nil)
            return false
        case .Restricted:
            return false
        case .Denied:
            // new iOS 8 feature: sane way of getting the user directly to the relevant prefs
            // I think the crash-in-background issue is now gone
            let alert = UIAlertController(title: "Need Authorization", message: "Wouldn't you like to authorize this app to use your Photos library?", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
                _ in
                let url = NSURL(string:UIApplicationOpenSettingsURLString)!
                UIApplication.sharedApplication().openURL(url)
            }))
            self.presentViewController(alert, animated:true, completion:nil)
            return false
        }
    }
    
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
        print("coeur")
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
        
        self.currentStatus()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "currentStatus", name: UIApplicationWillEnterForegroundNotification, object: nil)

        
    }
    
    //Get Message
    func textFieldShouldReturn(messageField: UITextField!) -> Bool {
        self.view.endEditing(true);
        //Set in current Object
        var Data:String = messageField.text
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
        
        if messageField.text == "" {
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
    
    @IBAction func doPick (sender:AnyObject!) {
        if !self.currentStatus() {
            println("not authorized")
            return
        }
        
        let src = UIImagePickerControllerSourceType.SavedPhotosAlbum
        let ok = UIImagePickerController.isSourceTypeAvailable(src)
        if !ok {
            println("alas")
            return
        }
        
        let arr = UIImagePickerController.availableMediaTypesForSourceType(src)
        if arr == nil {
            println("no available types")
            return
        }
        let picker = MyImagePickerController() // see comments below for reason
        picker.sourceType = src
        picker.mediaTypes = arr!
        picker.delegate = self
        
        picker.allowsEditing = false // try true
        
        // this will automatically be fullscreen on phone and pad, looks fine
        // note that for .PhotoLibrary, iPhone app must permit portrait orientation
        // if we want a popover, on pad, we can do that; just uncomment next line
        // picker.modalPresentationStyle = .Popover
        self.presentViewController(picker, animated: true, completion: nil)
        // ignore:
        if let pop = picker.popoverPresentationController {
            let v = sender as UIView
            pop.sourceView = v
            pop.sourceRect = v.bounds
        }
        
    }
}

extension CreateMessageViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // this has no effect
    func navigationControllerSupportedInterfaceOrientations(navigationController: UINavigationController) -> Int {
        return Int(UIInterfaceOrientationMask.Landscape.rawValue)
    }
    
    
    func imagePickerController(picker: UIImagePickerController!,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
            println(info[UIImagePickerControllerReferenceURL])
            
            
            var myURL = "\(info[UIImagePickerControllerReferenceURL]!)"
            println(myURL)
            
            //Set in current Object
            var Data:String = myURL
            var typeData:String = "photo"
            setData(Data,typeData: typeData)
            
            let url = info[UIImagePickerControllerMediaURL] as? NSURL
            
            var im = info[UIImagePickerControllerOriginalImage] as? UIImage
            var edim = info[UIImagePickerControllerEditedImage] as? UIImage
            if edim != nil {
                im = edim
            }
            self.dismissViewControllerAnimated(true) {
                let type = info[UIImagePickerControllerMediaType] as? String
                if type != nil {
                    switch type! {
                    case kUTTypeImage:
                        if im != nil {
                            self.showImage(im!)
                        }
                    default:break
                    }
                }
            }
    }
    
    func clearAll() {
        if self.childViewControllers.count > 0 {
            let av = self.childViewControllers[0] as AVPlayerViewController
            av.willMoveToParentViewController(nil)
            av.view.removeFromSuperview()
            av.removeFromParentViewController()
        }
        self.redView.subviews.map { ($0 as UIView).removeFromSuperview() }
    }
    
    func showImage(im:UIImage) {
        self.clearAll()
        let iv = UIImageView(image:im)
        iv.contentMode = .ScaleAspectFit
        iv.frame = self.redView.bounds
        self.redView.addSubview(iv)
    }
}
