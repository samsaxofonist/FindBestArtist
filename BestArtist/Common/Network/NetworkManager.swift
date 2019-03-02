//
//  NetworkManager.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 13.01.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import CoreLocation

struct ArtistKeys {
    static let name = "name"
    static let talent = "talent"
    static let description = "description"
    static let photoLink = "photoLink"
    static let youtubeLink = "youtubeLink"
    static let price = "price"
    static let cityName = "cityName"
    static let cityLatitude = "cityLat"
    static let cityLongitude = "cityLon"
    static let facebookID = "fbId"
    static let photoGaleryLinks = "photoGaleryLinks"
}

class NetworkManager {
    static func saveArtist(_ artist: Artist, finish: @escaping (()->()) ) {
        self.uploadProfilePhoto(artist.photo, forFacebookId: artist.facebookId, completion: { photoURL in
            self.uploadGalleryPhotos(artist.photoGalery, forFacebookId: artist.facebookId, completion: { photoURLs in
                let ref: DatabaseReference
                
                if let userId = artist.databaseId {
                    ref = Database.database().reference().child("users/\(userId)")
                } else {
                    ref = Database.database().reference().child("users").childByAutoId()
                }
                
                ref.setValue([ArtistKeys.name: artist.name,
                              ArtistKeys.talent: artist.talent,
                              ArtistKeys.description: artist.description,
                              ArtistKeys.photoLink: photoURL != nil ? photoURL!.absoluteString : "",
                              ArtistKeys.youtubeLink: artist.youtubeLink,
                              ArtistKeys.price: artist.price,
                              ArtistKeys.cityName: artist.city.name,
                              ArtistKeys.cityLatitude: artist.city.location.latitude,
                              ArtistKeys.cityLongitude: artist.city.location.longitude,
                              ArtistKeys.facebookID: artist.facebookId,
                              ArtistKeys.photoGaleryLinks: photoURLs.map { $0.absoluteString } ])
                finish()
            })
        })
    }
    
    private static func uploadProfilePhoto(_ photo: UIImage?, forFacebookId fbID: String, completion: @escaping ((URL?) -> Void)) {
        uploadAnyPhoto(photo, name: "\(fbID).png", completion: completion)
    }
    
    private static func uploadGalleryPhotos(_ photos: [UIImage], forFacebookId fbID: String, completion: @escaping (([URL]) -> Void)) {
        var allPhotosURL = [URL]()
        var countProcessedPhotos = 0
        
        for (index, onePhoto) in photos.enumerated() {
            uploadAnyPhoto(onePhoto, name: "\(fbID)-\(index).png", completion: { photoURL in
                // ОБЕСПЕЧИТЬ ПОТОКОБЕЗОПАСНОСТЬ!
                
                // сохранить URL в массив, чтобы накопить
                countProcessedPhotos += 1
                guard let url = photoURL else { return }
                allPhotosURL.append(url)
                
                // выяснить, не последняя ли картинка загружена
                if countProcessedPhotos == photos.count {
                    // если последняя - вызвать completion с массивом всех URL
                    completion(allPhotosURL)
                }
            })
        }
    }
    
    private static func uploadAnyPhoto(_ photo: UIImage?, name: String, completion: @escaping ((URL?) -> Void)) {
        guard let photo = photo else {
            completion(nil)
            return
        }
        
        let riversRef = Storage.storage().reference().child("images/\(name)")
        let _ = riversRef.putData(photo.pngData()!, metadata: nil) { (metadata, error) in
            riversRef.downloadURL { (url, error) in
                completion(url)
            }
        }
    }
    
    static func loadArtists(completion: @escaping (([Artist], Error?) -> Void)) {
        let ref = Database.database().reference().child("users")
        
        ref.observeSingleEvent(of: .value, with: { data in
            guard let jsonData = data.value as? [String: [String: Any]] else { return }
            var artists = [Artist]()
            
            for (userId, value) in jsonData {
                let artist = Artist()
                artist.databaseId = userId
                artist.name = (value[ArtistKeys.name] as? String) ?? ""
                artist.talent = (value[ArtistKeys.talent] as? String) ?? ""
                artist.description = (value[ArtistKeys.description] as? String) ?? ""
                artist.photoLink = value[ArtistKeys.photoLink] as? String
                artist.youtubeLink = (value[ArtistKeys.youtubeLink] as? String) ?? ""
                artist.price = (value[ArtistKeys.price] as? Int) ?? 0
                artist.facebookId = (value[ArtistKeys.facebookID] as? String) ?? ""
                
                let cityName = (value[ArtistKeys.cityName] as? String) ?? ""
                let lat = (value[ArtistKeys.cityLatitude] as? Double) ?? 0
                let lon = (value[ArtistKeys.cityLongitude] as? Double) ?? 0
                artist.city = City(name: cityName, location: CLLocationCoordinate2D(latitude: lat, longitude: lon))
                artists.append(artist)
            }
            
            completion(artists, nil)
        }) { error in
            completion([], error)
        }
        
    }
}
