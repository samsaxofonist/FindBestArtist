//
//  MyProfileViewModel.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 04.07.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

final class MyProfileViewModel {
    
    func getProfilePhoto(artist: Artist?, block: @escaping ((UIImage?, URL?) -> Void)) {
        if let existedPhoto = artist?.photo, let link = artist?.photoLink, let photoURL = URL(string: link) {
            block(existedPhoto, photoURL)
            return
        }

        if let link = artist?.photoLink, let photoURL = URL(string: link) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: photoURL)
                DispatchQueue.main.async {
                    if let imageData = data {
                        block(UIImage(data: imageData), photoURL)
                    } else {
                        block(nil, photoURL)
                    }
                }
            }
        } else if GlobalManager.myUser?.facebookId == artist?.facebookId {
            DispatchQueue.global().async {
                NetworkManager.loadFacebookPhoto(block: block)
            }
        } else {
            block(nil, nil)
        }
    }
}
