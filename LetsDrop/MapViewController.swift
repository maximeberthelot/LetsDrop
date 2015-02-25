//
//  MapViewController.swift
//  LetsDrop
//
//  Created by Maxime Berthelot on 23/02/2015.
//  Copyright (c) 2015 Maxime Berthelot. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AddressBookUI



class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate,UISearchBarDelegate {
    
    var request = MKLocalSearchRequest()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var createMessageBtn: SpringButton!
    
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set Dropped Btn ********************
        var bounds: CGRect = UIScreen.mainScreen().bounds,
        width:CGFloat = bounds.size.width,
        height:CGFloat = bounds.size.height;
        
        println(height)
          println(width)
        createMessageBtn.center = (CGPointMake(self.view.center.x, self.view.center.y - createMessageBtn.frame.height+15))
        
        //
        searchBar.showsScopeBar = true
        searchBar.delegate = self
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            manager.requestAlwaysAuthorization()
        }
        if CLLocationManager.locationServicesEnabled() {
            
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.startMonitoringSignificantLocationChanges()
            println("started monitoring")
        }
        self.mapView.delegate = self
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var locValue:CLLocationCoordinate2D = manager.location.coordinate
        var location = CLLocationCoordinate2D(
            latitude: locValue.latitude,
            longitude: locValue.longitude
        )
        
        var span = MKCoordinateSpanMake(0.5, 0.5)
        var region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: true)
    }
 
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location " + error.localizedDescription)
    }
    
    
    
    
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
       var currentLocation = mapView.centerCoordinate
        
        NSLog("Lon: \(currentLocation.longitude.description) Lat: \(currentLocation.latitude.description)")
        
        //Convert lat & long
        var longitude :CLLocationDegrees = Double(currentLocation.longitude),
            latitude :CLLocationDegrees = Double(currentLocation.latitude),
        // push Lat & lon in var location
            location = CLLocation(latitude: latitude, longitude: longitude);
        CLGeocoder().reverseGeocodeLocation(location) {
            
            (placemarks : [AnyObject]!, error : NSError!) in
            if placemarks != nil {
                let p = placemarks[0] as CLPlacemark     
                let s = ABCreateStringWithAddressDictionary(p.addressDictionary, false)
                println("you are at:\n\(s)") // do something with address
                self.searchBar.text = String(s);
            }
        }
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Search & SetMap with SearchBar
    func searchBarSearchButtonClicked(searchBar: UISearchBar!) {
        searchBar.resignFirstResponder()
        let s = searchBar.text
        if s == nil || countElements(s) < 5 { return }
        let geo = CLGeocoder()
        geo.geocodeAddressString(s) {
            (placemarks : [AnyObject]!, error : NSError!) in
            if nil == placemarks {
                println(error.localizedDescription)
                return
            }
            self.mapView.showsUserLocation = false
            let p = placemarks[0] as CLPlacemark
            let mp = MKPlacemark(placemark:p)
            self.mapView.setRegion(
                MKCoordinateRegionMakeWithDistance(mp.coordinate, 1000, 1000),
                animated: true)
        }
    }
    
    
    //SetCenterMap
    
    @IBAction func findMyLocate(sender: UIButton) {
        
        var userLocate:CLLocationCoordinate2D = manager.location.coordinate
        var location = CLLocationCoordinate2D(
            latitude: userLocate.latitude,
            longitude: userLocate.longitude
        )
        var bounds: CGRect = UIScreen.mainScreen().bounds,
        width:CGFloat = bounds.size.width,
        height:CGFloat = bounds.size.height;
        
        createMessageBtn.center = (CGPointMake(self.view.center.x, self.view.center.y - createMessageBtn.frame.height+15))
        var mapCamera = MKMapCamera(lookingAtCenterCoordinate: location, fromEyeCoordinate: location, eyeAltitude: 1000)
        
        mapView.setCamera(mapCamera, animated: true)
        
    }
    
    
    //Create a Message
    
    @IBAction func createMessage(sender: AnyObject) {
       
        
        var createMessageStoryboard = UIStoryboard(name: "createmessage", bundle: nil)
        var controller = createMessageStoryboard.instantiateViewControllerWithIdentifier("InitialCMessageViewController") as UIViewController
        controller.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
}

