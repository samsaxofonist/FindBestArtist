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
    
    let zoneCircleRadius: Double = 125
    var userLocationIsTaken = false
    var allArtists: [User]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyTheme(theme: ThemeManager.theme)
        setupLocationManager()
        addSomeMarks()
    }
    
    func applyTheme(theme: Theme) {
    }
    
    func setupLocationManager() {
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
        calculateRadius()
        dismiss(animated: true, completion: nil)
    }
    
    func addSomeMarks() {
        // Взять массив координат каждого артиста
        let usersLocations: [CLLocationCoordinate2D] = allArtists.map { $0.city.location }
        // Взять только уникальные координаты, которые не повторяются
        let uniqueLocations = Set<CLLocationCoordinate2D>(usersLocations)
        
        for location in uniqueLocations {
            let numberOfUsers = allArtists.filter { $0.city.location == location }.count
            
            let annotaion = MKPointAnnotation()
            annotaion.title = "\(numberOfUsers) artists"
            annotaion.coordinate = location
            map.addAnnotation(annotaion)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard userLocationIsTaken == false else { return }
        guard let latestLocation = locations.first else { return }
        let regionRadius: CLLocationDistance = 100000
        let region = MKCoordinateRegion(center: latestLocation.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        map.setRegion(region, animated: true)
        userLocationIsTaken = true
    }
    
    func calculateRadius() {
        let rect = map.visibleMapRect
        let rightMapPoint = MKMapPoint(x: rect.minX, y: rect.midY)
        let leftMapPoint = MKMapPoint(x: rect.maxX, y: rect.midY)
        let screenMapWidthInMeters = rightMapPoint.distance(to: leftMapPoint)
        
        let metersPerPixel = screenMapWidthInMeters / Double(UIScreen.main.bounds.width)
        
        let centerPointCoordinates = map.centerCoordinate
        let centerPointRadiusInMeters = zoneCircleRadius * metersPerPixel        
        GlobalManager.filterDistance = FilterType.distance(center: centerPointCoordinates, radius: centerPointRadiusInMeters)
    }
    
}

extension CLLocationCoordinate2D: Hashable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
    public var hashValue: Int {
        return (latitude.hashValue&*397) &+ longitude.hashValue
    }
}
