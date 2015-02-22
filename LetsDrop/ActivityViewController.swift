//
//  NavViewController.swift
//  LetsDrop
//
//  Created by Maxime Berthelot on 22/02/2015.
//  Copyright (c) 2015 Maxime Berthelot. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var RecVc :ReceivedViewController =  ReceivedViewController(nibName: "ReceivedViewController", bundle: nil);
        var DropVc :DroppedViewController =  DroppedViewController(nibName: "DroppedViewController", bundle: nil);
        
        
        tabBarController?.customizableViewControllers
        self.addChildViewController(RecVc);
        self.scrollView!.addSubview(RecVc.view);
        RecVc.didMoveToParentViewController(self);
        
        //Set view
        self.addChildViewController(DropVc);
        self.scrollView!.addSubview(DropVc.view);
        DropVc.didMoveToParentViewController(self);
        
        var bounds: CGRect = UIScreen.mainScreen().bounds,
        width:CGFloat = bounds.size.width,
        height:CGFloat = bounds.size.height;
        
        var RFrame :CGRect = RecVc.view.frame,
        DFrame :CGRect = DropVc.view.frame;
        DFrame.origin.x = 2*DFrame.width;
        
        RFrame.origin.x = width;
        DropVc.view.frame = RFrame;
        
        
        //Set a greate contentView
        self.scrollView!.contentSize = CGSizeMake(2*width, height-30);
        
        //SetColor
        println(scrollView.contentOffset.x)
        if scrollView.contentOffset.x > 100{
            println("cucou")
        } else{
            println("fhfhf \(width)")
            
        }

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBOutlet weak var dropBtn: UIButton!
    @IBOutlet weak var recBtn: UIButton!
    
    // Slide go to ReceivedView
    @IBAction func recBtn(sender: UIButton) {
        
        //recBtn.titleLabel!.textColor = UIColor(hex: "#FFFF")
        //dropBtn.titleLabel!.textColor = UIColor(hex: "#efefef")
        scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
    }
    
    // Slide go to DroppedView
    @IBAction func dropBtn(sender: UIButton) {
        var bounds: CGRect = UIScreen.mainScreen().bounds
        var width:CGFloat = bounds.size.width
        //dropBtn.titleLabel!.textColor = UIColor(hex: "#FFFF")
      //  recBtn.titleLabel!.textColor = UIColor(hex: "#efefef")
        
        
        
        
        scrollView.setContentOffset(CGPoint(x: width,y: 0), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

