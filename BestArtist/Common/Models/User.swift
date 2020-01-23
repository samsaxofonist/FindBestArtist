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
    var type: UserType
    var databaseId: String?
    var facebookId: String
    var name: String
    var photo: UIImage?
    var photoLink: String?

    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.facebookId == rhs.facebookId
    }

    init(type: UserType = .customer, facebookId: String, name: String) {
        self.type = type
        self.facebookId = facebookId
        self.name = name
    }
}

class Artist: User {
    var talent: String
    var description: String
    var city: City
    var country: String
    var price: Int

    var youtubeLinks = [String]()
    var feedbackLinks = [String]()

    var galleryPhotos = [UIImage]()
    var galleryPhotosLinks = [String]()
    var busyDates = [TimeInterval]()

    init(facebookId: String,
         name: String,
         talent: String,
         description: String,
         city: City,
         country: String,
         price: Int,
         photoLink: String
    ) {
        self.talent = talent
        self.description = description
        self.city = city
        self.country = country
        self.price = price
        super.init(type: .artist, facebookId: facebookId, name: name)
        self.photoLink = photoLink
    }
}
