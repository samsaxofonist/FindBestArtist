//
//  File.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 16.01.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import Foundation
import UIKit

enum UserType: Int {
    case artist = 1
    case customer = 2
}

class User: Equatable {
    var type: UserType!
    var databaseId: String?
    var facebookId: String = ""


    var name: String = ""
    var talent: String = ""
    var description: String = ""
    var youtubeLinks: [String] = []
    var feedbackLinks: [String] = []
    var city: City!
    var country: String?
    var price: Int = 0
    
    var photo: UIImage?
    var photoLink: String?
    
    var galleryPhotos = [UIImage]()
    var galleryPhotosLinks = [String]()
    var busyDates = [TimeInterval]()
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.facebookId == rhs.facebookId
    }
}
