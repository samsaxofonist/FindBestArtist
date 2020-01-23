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

class MyProfileViewModel {
    
    func getProfilePhoto(artist: Artist?, block: @escaping ((UIImage?, URL?) -> Void)) {
        // Оптимизировать и не грузить каждый раз
        if let link = artist?.photoLink,
            let photoURL = URL(string: link),
            let data = try? Data(contentsOf: photoURL) {
            block(UIImage(data: data), photoURL)
            return
        }

        if GlobalManager.myUser?.facebookId == artist?.facebookId {
            DispatchQueue.global().async {
                NetworkManager.loadFacebookPhoto(block: block)
            }
        }
    }
}
