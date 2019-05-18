//
//  Geocoder.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 13.01.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class Geocoder {
    static func getCityName(locationObject: MKLocalSearchCompletion, completion: @escaping ((City) -> Void)) {
        getCoordinates(locationObject: locationObject) { coordinate in
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error -> Void in
                guard let placeMark = placemarks?.first else { return }
                
                if let cityName = placeMark.subAdministrativeArea {
                    let city = City(name: cityName, location: coordinate)
                    completion(city)
                }
            })
        }
    }
    
    private static func getCoordinates(locationObject: MKLocalSearchCompletion, completion: @escaping ((CLLocationCoordinate2D) -> Void)) {
        let searchRequest = MKLocalSearch.Request(completion: locationObject)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { (response, error) in
            guard let mapItem = response?.mapItems[0] else { return }
            let coordinate = mapItem.placemark.coordinate
            completion(coordinate)
        }
    }
}
