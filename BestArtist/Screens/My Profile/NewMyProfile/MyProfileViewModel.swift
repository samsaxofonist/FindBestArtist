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
import Kingfisher

final class MyProfileViewModel {
    
    func getProfilePhoto(artist: Artist?, block: @escaping ((UIImage?, URL?) -> Void)) {
        if let existedPhoto = artist?.photo, let link = artist?.photoLink, let photoURL = URL(string: link) {
            block(existedPhoto, photoURL)
            return
        }

        if let link = artist?.photoLink, let photoURL = URL(string: link) {
            let resource = ImageResource(downloadURL: photoURL)
            _ = KingfisherManager.shared.retrieveImage(with: .network(resource)) { result in
                switch result {
                case .success(let imageResult):
                    block(imageResult.image, photoURL)
                case .failure:
                    block(nil, photoURL)
                }
            }            
        } else if GlobalManager.myUser?.facebookId == artist?.facebookId {
            NetworkManager.loadFacebookPhoto(block: block)
        } else {
            block(nil, nil)
        }
    }
}
