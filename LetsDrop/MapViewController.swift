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
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        var annotation = MKPointAnnotation()
        annotation.setCoordinate(location)
        annotation.title = "Roatan"
        annotation.subtitle = "Honduras"
        
        mapView.addAnnotation(annotation)
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location " + error.localizedDescription)
    }
    
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        
        println("hey@")
        
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
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotation(mp)
            self.mapView.setRegion(
                MKCoordinateRegionMakeWithDistance(mp.coordinate, 1000, 1000),
                animated: true)
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
