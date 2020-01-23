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
        if let link = artist?.photoLink,
            let photoURL = URL(string: link),
            let data = try? Data(contentsOf: photoURL) {
            block(UIImage(data: data), photoURL)
        }

        DispatchQueue.global().async {
            FBSDKProfile.loadCurrentProfile { (profile, error) in
                guard let url = FBSDKProfile.current()?.imageURL(for: .normal, size: CGSize(width: 1000, height: 1000)) else {
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
