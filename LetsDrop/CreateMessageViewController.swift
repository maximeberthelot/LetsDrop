//
//  CreateMessageViewController.swift
//  LetsDrop
//
//  Created by Maxime Berthelot on 25/02/2015.
//  Copyright (c) 2015 Maxime Berthelot. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos
import CoreData
import AVKit


class CreateMessageViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var cancelBtn: DesignableButton!
    @IBOutlet var myPicture : UIView!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var titleLabel: DesignableLabel!
    @IBOutlet weak var sendBtn: DesignableButton!
    
    
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
        sendBtn.autohide = true
        println("result")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBtn(sender: AnyObject) {
        var navigationStoryboard = UIStoryboard(name: "navigation", bundle: nil)
        var controller = navigationStoryboard.instantiateViewControllerWithIdentifier("InitialViewController") as UIViewController
        controller.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        self.presentViewController(controller, animated: true, completion: nil)
      
    }
    
    // Get Library Picture
    
    func determineStatus() -> Bool {
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
            let alert = UIAlertController(title: "Need Authorization", message: "Wouldn't you like to authorize Let's Drop to use your Photos library?", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: {
                _ in
                let url = NSURL(string:UIApplicationOpenSettingsURLString)!
                UIApplication.sharedApplication().openURL(url)
            }))
            self.presentViewController(alert, animated:true, completion:nil)
            return false
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.determineStatus()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "determineStatus", name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    @IBAction func doPick (sender:AnyObject!) {
        if !self.determineStatus() {
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
        
        picker.allowsEditing = false
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
    
    
    func imagePickerController(picker: UIImagePickerController!,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
            println(info[UIImagePickerControllerReferenceURL])
            
            var myPhotoUrl: String = info[UIImagePickerControllerReferenceURL] as String
           
            
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
                            self.showImage(im!, myPhotoUrl: myPhotoUrl)
                        }
                    default:break
                    }
                }
            }
            
    }
    
    func clearAll(myPhotoUrl: String) {
        if self.childViewControllers.count > 0 {
            let av = self.childViewControllers[0] as AVPlayerViewController
            av.willMoveToParentViewController(nil)
            av.view.removeFromSuperview()
            av.removeFromParentViewController()
        }
        self.myPicture.subviews.map { ($0 as UIView).removeFromSuperview() }
        
        println(myPhotoUrl)
       // var Data:String = myPhotoUrl
       // var typeData:String = "photo"
       // self.setData(Data,typeData: typeData)
    }
    
    func showImage(im:UIImage, myPhotoUrl:String) {
        self.clearAll(myPhotoUrl)
        let iv = UIImageView(image:im)
        iv.contentMode = .ScaleAspectFit
        iv.frame = self.myPicture.bounds
        self.myPicture.addSubview(iv)
        
          println(myPhotoUrl)
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
}