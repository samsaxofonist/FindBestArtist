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
import Kingfisher

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
    static func saveArtist(_ artist: Artist, finish: @escaping (()->())) {
        let ref: DatabaseReference

        if let userId = artist.databaseId {
            ref = Database.database().reference().child("users/\(userId)")
            updateArtist(ref: ref, artist: artist, userId: userId, finish: finish)
        } else {
            ref = Database.database().reference().child("users").childByAutoId()
            createNewArtist(ref: ref, artist: artist, finish: finish)
        }
    }

    static func updateArtist(ref: DatabaseReference, artist: Artist, userId: String, finish: @escaping (()->())) {
        ref.observeSingleEvent(of: .value) { data in
            guard let jsonData = data.value as? [String: Any] else { return }
            guard let existedArtist = parseArtist(from: jsonData, userId: userId) else { return }

            let uploadGroup = DispatchGroup()

            let uploadPhotoCompletion: ((URL?) -> Void) = { photoURL in
                if let url = photoURL {
                    ref.updateChildValues([ArtistKeys.photoLink: url.absoluteString])
                }
                uploadGroup.leave()
            }

            let uploadGalleryPhotosCompletion: (([URL]) -> Void) = { urls in
                ref.updateChildValues([ArtistKeys.photoGaleryLinks: urls.map { $0.absoluteString }])
                uploadGroup.leave()
            }

            if let link = existedArtist.photoLink,
                let photoURL = URL(string: link),
                let data = try? Data(contentsOf: photoURL) {
                existedArtist.photo = UIImage(data: data)
            }

            if existedArtist.photo?.pngData() != artist.photo?.pngData() {
                uploadGroup.enter()
                self.uploadProfilePhoto(artist.photo, forFacebookId: artist.facebookId, completion: uploadPhotoCompletion)
            }

            if existedArtist.galleryPhotosLinks.sorted() != artist.galleryPhotosLinks.sorted() {
                uploadGroup.enter()
                self.uploadGalleryPhotos(artist.galleryPhotos, forFacebookId: artist.facebookId, completion: uploadGalleryPhotosCompletion)
            }

            uploadGroup.enter()
            updateArtistsMainInfo(ref: ref, artist: artist)
            uploadGroup.leave()

            uploadGroup.notify(queue: DispatchQueue.main) {
                finish()
            }
        }
    }

    static func updateArtistsMainInfo(ref: DatabaseReference, artist: Artist) {
        ref.updateChildValues([
            ArtistKeys.name: artist.name,
            ArtistKeys.talent: artist.talent.description,
            ArtistKeys.description: artist.description,
            ArtistKeys.youtubeLink: artist.youtubeLinks,
            ArtistKeys.feedbackLink: artist.feedbackLinks,
            ArtistKeys.price: artist.price,
            ArtistKeys.cityName: artist.city.name,
            ArtistKeys.cityLatitude: artist.city.location.latitude,
            ArtistKeys.cityLongitude: artist.city.location.longitude,
            ArtistKeys.facebookID: artist.facebookId,
            ArtistKeys.busyDates: artist.busyDates,
            ArtistKeys.countryName: artist.country,
            ArtistKeys.type: artist.type.rawValue
        ])
    }

    static func createNewArtist(ref: DatabaseReference, artist: Artist, finish: @escaping (()->())) {
        self.uploadProfilePhoto(artist.photo, forFacebookId: artist.facebookId, completion: { photoURL in
            self.uploadGalleryPhotos(artist.galleryPhotos, forFacebookId: artist.facebookId, completion: { photoURLs in
                ref.setValue([ArtistKeys.name: artist.name,
                              ArtistKeys.talent: artist.talent.description,
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
                              ArtistKeys.type: artist.type.rawValue,
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
                if let artist = parseArtist(from: value, userId: userId) {
                    artists.append(artist)
                }
            }
            
            completion(artists, nil)
        }) { error in
            completion([], error)
        }
    }

    static func loadArtist(byFacebookId facebookId: String, completion: @escaping ((Artist?) -> Void)) {
        let ref = Database.database().reference().child("users")

        ref.queryOrdered(byChild: "fbId")
            .queryEqual(toValue: facebookId)
            .observeSingleEvent(of: .value, with: { data in
                guard let jsonData = data.value as? [String: [String: Any]] else {
                    return completion(nil)
                }
                var artists = [Artist]()

                for (userId, value) in jsonData {
                    if let artist = parseArtist(from: value, userId: userId) {
                        artists.append(artist)
                    }
                }
                completion(artists.first)
        })
    }
}

private extension FirebaseManager {

    static func parseArtist(from value: [String : Any], userId: String) -> Artist? {
        guard let typeValue = value[ArtistKeys.type] as? Int, let userType = UserType(rawValue: typeValue), userType == .artist else { return nil }

        guard let name = value[ArtistKeys.name] as? String,
            let talent = value[ArtistKeys.talent] as? String,
            let description = value[ArtistKeys.description] as? String,
            let price = value[ArtistKeys.price] as? Int,
            let facebookId = value[ArtistKeys.facebookID] as? String,
            let cityName = value[ArtistKeys.cityName] as? String,
            let lat = value[ArtistKeys.cityLatitude] as? Double,
            let lon = value[ArtistKeys.cityLongitude] as? Double,
            let country = value[ArtistKeys.countryName] as? String else {
                return nil
        }

        let photoLink = value[ArtistKeys.photoLink] as? String
        let realTalent = Talent(string: talent)
        let artist = Artist(facebookId: facebookId, name: name, talent: realTalent, description: description, city: City(name: cityName, location: CLLocationCoordinate2D(latitude: lat, longitude: lon)), country: country, price: price, photoLink: photoLink ?? "")

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
        return artist
    }

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
