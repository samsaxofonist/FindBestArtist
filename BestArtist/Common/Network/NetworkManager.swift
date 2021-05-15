//
//  NetworkManager.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 18.05.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

final class NetworkManager {

    static func saveCustomer(_ customer: User, finish: @escaping (()->())) {
        loadFacebookPhoto { image, url in
            customer.photo = image
            FirebaseManager.saveCustomer(customer, finish: finish)
        }
    }

    static func loadCustomers(completion: @escaping (([User], Error?) -> Void)) {
    }
    
    static func saveArtist(_ artist: Artist, photoChanged: Bool, galleryPhotosChanged: Bool, finish: @escaping (()->())) {
        FirebaseManager.saveArtist(artist, photoChanged: photoChanged, galleryPhotosChanged: galleryPhotosChanged, finish: finish)
    }
    
    static func loadArtists(completion: @escaping (([Artist], Error?) -> Void)) {
        FirebaseManager.loadArtists(completion: completion)
    }

    static func loadFacebookPhoto(block: @escaping ((UIImage?, URL?) -> Void)) {
        DispatchQueue.global().async {
            if let profile = GlobalManager.fbProfile {
                guard let url = profile.imageURL(forMode: .normal, size: CGSize(width: 1000, height: 1000)) else {
                    block(nil, nil)
                    return
                }
                guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
                    block(nil, nil)
                    return
                }
                DispatchQueue.main.async {
                    block(image, url)
                }
            } else {
                Profile.loadCurrentProfile { (profile, error) in
                    guard let url = Profile.current?.imageURL(forMode: .normal, size: CGSize(width: 1000, height: 1000)) else {
                        block(nil, nil)
                        return
                    }
                    guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
                        block(nil, nil)
                        return
                    }
                    DispatchQueue.main.async {
                        block(image, url)
                    }
                }
            }
        }
    }
}
