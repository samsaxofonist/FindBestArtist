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

struct Address {
    let postalCode: String
    let street: String
    let streetNumber: String
    let city: String
    let country: String
}

class Geocoder {

    static func getDetailedAddress(locationObject: MKLocalSearchCompletion, completion: @escaping ((Address?) -> Void)) {
        getCoordinates(locationObject: locationObject) { coordinate in
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error -> Void in
                guard let placeMark = placemarks?.first else { return }

                if let cityName = placeMark.subAdministrativeArea,
                    let countryName = placeMark.country,
                    let postalCode = placeMark.postalCode,
                    let street = placeMark.thoroughfare,
                    let streetNumber = placeMark.subThoroughfare {
                    let address = Address(postalCode: postalCode, street: street, streetNumber: streetNumber, city: cityName, country: countryName)
                    completion(address)
                } else {
                    completion(nil)
                }
            })
        }
    }

    static func getCityAndCountry(locationObject: MKLocalSearchCompletion, completion: @escaping ((City, String) -> Void)) {
        getCoordinates(locationObject: locationObject) { coordinate in
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error -> Void in
                guard let placeMark = placemarks?.first else { return }
                
                // Получили имя города и страны
                if let cityName = placeMark.locality, let countryName = placeMark.country {
                    getLocation(forName: cityName, completion: { location in
                        guard let cityLocation = location else { return }
                        let city = City(name: cityName, location: cityLocation.coordinate)
                        completion(city, countryName)
                    })
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
    
    static func getLocation(forName name: String, completion: @escaping(CLLocation?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(name) { placemarks, error in
            
            guard error == nil else {
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?.first else {
                completion(nil)
                return
            }
            
            guard let location = placemark.location else {
                completion(nil)
                return
            }
            
            completion(location)
        }
    }
}
