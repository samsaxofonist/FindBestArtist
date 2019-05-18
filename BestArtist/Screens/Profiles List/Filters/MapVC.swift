//
//  MapVC.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 18.05.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func apply(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else { return }
        let regionRadius: CLLocationDistance = 100000
        let region = MKCoordinateRegion(center: latestLocation.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        map.setRegion(region, animated: true)
    }
}

/*
 MKMapRect currentRect = mapView.visibleMapRect;
 MKMapPoint farEastPoint = MKMapPointMake(MKMapRectGetMinX(currentRect), MKMapRectGetMidY(currentRect));
 MKMapPoint farWestPoint = MKMapPointMake(MKMapRectGetMaxX(currentRect), MKMapRectGetMidY(currentRect));
 double currentDis = MKMetersBetweenMapPoints(farEastPoint, farWestPoint);
 */
