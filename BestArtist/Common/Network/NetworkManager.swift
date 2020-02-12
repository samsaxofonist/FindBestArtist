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
    
    static func saveArtist(_ artist: Artist, finish: @escaping (()->())) {
        FirebaseManager.saveArtist(artist, finish: finish)
    }
    
    static func loadArtists(completion: @escaping (([Artist], Error?) -> Void)) {
        FirebaseManager.loadArtists(completion: completion)
    }

    static func loadFacebookPhoto(block: @escaping ((UIImage?, URL?) -> Void)) {
        DispatchQueue.global().async {
            if let profile = GlobalManager.fbProfile {
                guard let url = profile.imageURL(for: .normal, size: CGSize(width: 1000, height: 1000)) else {
                    block(nil, nil)
                    return
                }
                guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
                    block(nil, nil)
                    return
                }
                block(image, url)
            } else {
                FBSDKProfile.loadCurrentProfile { (profile, error) in
                    guard let url = FBSDKProfile.current()?.imageURL(for: .normal, size: CGSize(width: 1000, height: 1000)) else {
                        block(nil, nil)
                        return
                    }
                    guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
                        block(nil, nil)
                        return
                    }
                    block(image, url)
                }
            }
        }
    }
}
