//
//  FirebaseManager.swift
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
    static let feedbackLink = "feedbackLink"
    static let price = "price"
    static let cityName = "cityName"
    static let cityLatitude = "cityLat"
    static let cityLongitude = "cityLon"
    static let countryName = "countryName"
    static let facebookID = "fbId"
    static let photoGaleryLinks = "photoGaleryLinks"
    static let busyDates = "busyDates"
    static let type = "type"
}

class FirebaseManager {
    static func saveArtist(_ artist: Artist, finish: @escaping (()->()) ) {
        self.uploadProfilePhoto(artist.photo, forFacebookId: artist.facebookId, completion: { photoURL in
            self.uploadGalleryPhotos(artist.galleryPhotos, forFacebookId: artist.facebookId, completion: { photoURLs in
                let ref: DatabaseReference
                
                if let userId = artist.databaseId {
                    ref = Database.database().reference().child("users/\(userId)")
                } else {
                    ref = Database.database().reference().child("users").childByAutoId()
                }
                
                ref.setValue([ArtistKeys.name: artist.name,
                              ArtistKeys.talent: artist.talent,
                              ArtistKeys.description: artist.description,
                              ArtistKeys.photoLink: photoURL != nil ? photoURL?.absoluteString : "",
                              ArtistKeys.youtubeLink: artist.youtubeLinks,
                              ArtistKeys.feedbackLink: artist.feedbackLinks,
                              ArtistKeys.price: artist.price,
                              ArtistKeys.cityName: artist.city.name,
                              ArtistKeys.cityLatitude: artist.city.location.latitude,
                              ArtistKeys.cityLongitude: artist.city.location.longitude,
                              ArtistKeys.facebookID: artist.facebookId,
                              ArtistKeys.busyDates: artist.busyDates,
                              ArtistKeys.countryName: artist.country,
                              ArtistKeys.photoGaleryLinks: photoURLs.map { $0.absoluteString } ])
                finish()
            })
        })
    }
    
    static func loadArtists(completion: @escaping (([Artist], Error?) -> Void)) {
        let ref = Database.database().reference().child("users")
        
        ref.observeSingleEvent(of: .value, with: { data in
            guard let jsonData = data.value as? [String: [String: Any]] else { return }
            var artists = [Artist]()
            
            for (userId, value) in jsonData {
                guard let typeValue = value[ArtistKeys.type] as? Int, let userType = UserType(rawValue: typeValue), userType == .artist else { continue }

                guard let name = value[ArtistKeys.name] as? String,
                    let talent = value[ArtistKeys.talent] as? String,
                    let description = value[ArtistKeys.description] as? String,
                    let photoLink = value[ArtistKeys.photoLink] as? String,
                    let price = value[ArtistKeys.price] as? Int,
                    let facebookId = value[ArtistKeys.facebookID] as? String,
                    let cityName = value[ArtistKeys.cityName] as? String,
                    let lat = value[ArtistKeys.cityLatitude] as? Double,
                    let lon = value[ArtistKeys.cityLongitude] as? Double,
                    let country = value[ArtistKeys.countryName] as? String else {
                        continue
                }

                let artist = Artist(facebookId: facebookId, name: name, talent: talent, description: description, city: City(name: cityName, location: CLLocationCoordinate2D(latitude: lat, longitude: lon)), country: country, price: price, photoLink: photoLink)

                artist.databaseId = userId

                if let youtubeLinks = value[ArtistKeys.youtubeLink] as? [String] {
                    artist.youtubeLinks = youtubeLinks
                }

                if let feedbackLinks = value[ArtistKeys.feedbackLink] as? [String] {
                    artist.feedbackLinks = feedbackLinks
                }

                if let galleryPhotosLinks = value[ArtistKeys.photoGaleryLinks] as? [String] {
                    artist.galleryPhotosLinks = galleryPhotosLinks
                }

                if let busyDates = value[ArtistKeys.busyDates] as? [Double] {
                    artist.busyDates = busyDates
                }
                artists.append(artist)
            }
            
            completion(artists, nil)
        }) { error in
            completion([], error)
        }
        
    }
}

private extension FirebaseManager {
    private static func uploadProfilePhoto(_ photo: UIImage?, forFacebookId fbID: String, completion: @escaping ((URL?) -> Void)) {
        uploadAnyPhoto(photo, name: "\(fbID).png", completion: completion)
    }

    private static func uploadGalleryPhotos(_ photos: [UIImage], forFacebookId fbID: String, completion: @escaping (([URL]) -> Void)) {
        var allPhotosURL = [URL]()
        var countProcessedPhotos = 0

        guard photos.count > 0 else {
            completion([])
            return
        }

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
}
