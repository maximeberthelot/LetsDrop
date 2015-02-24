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
    @IBOutlet var setButton: UIButton!
    
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.showsScopeBar = true
        searchBar.delegate = self
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            manager.requestAlwaysAuthorization()
        }
        
        setButton.layer.cornerRadius = 5
        
     
        let pinImage: UIImageView = UIImageView(image: UIImage(named:"pin1"))
        pinImage.center = (CGPointMake(self.view.center.x, self.view.center.y - pinImage.frame.height))
        self.mapView.delegate = self
        self.mapView.addSubview(pinImage)
        
        
        if CLLocationManager.locationServicesEnabled() {
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.startMonitoringSignificantLocationChanges()
            println("started monitoring")
        }
       
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var locValue:CLLocationCoordinate2D = manager.location.coordinate
        println("locations = \(locValue.latitude) \(locValue.longitude)")
        
        
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
        var longitude :CLLocationDegrees = Double(currentLocation.longitude)
        var latitude :CLLocationDegrees = Double(currentLocation.latitude)
        // push Lat & lon in var location
        var location = CLLocation(latitude: latitude, longitude: longitude)
        println(location)
        

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
       
        CLGeocoder().geocodeAddressString(s) {
            (placemarks : [AnyObject]!, error : NSError!) in
            if nil == placemarks {
                println(error.localizedDescription)
                return
            }
            self.mapView.showsUserLocation = false
            let p = placemarks[0] as CLPlacemark
            let mp = MKPlacemark(placemark:p)
        }

        
        
    }
    
    //SetCenterMap
    
    @IBAction func centerMap(sender: UIButton) {
        println("myaciton");
        var locValue:CLLocationCoordinate2D = manager.location.coordinate
        println("locations = \(locValue.latitude) \(locValue.longitude)")
        
        
        var location = CLLocationCoordinate2D(
            latitude: locValue.latitude,
            longitude: locValue.longitude
        )
        
        var span = MKCoordinateSpanMake(0.5, 0.5)
        var region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: true)
    }

    
}
