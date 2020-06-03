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
    var city: City

    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.facebookId == rhs.facebookId
    }

    init(type: UserType = .customer, facebookId: String, name: String, city: City) {
        self.type = type
        self.facebookId = facebookId
        self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        self.city = city
    }
}

enum Talent: Equatable {
    case music(MusicTalent)
    case moderator
    case photo(PhotoTalent)
    case dj

    enum MusicTalent: String {
        case piano = "Piano"
        case saxophone = "Saxophone"
    }

    enum PhotoTalent: String {
        case photo = "Photograph"
        case video = "Videograph"
        case photobox = "Photobox"
    }

    func isGlobalTalentEqual(to: Talent) -> Bool {
        switch (self, to) {
        case (.music, .music):
            return true

        case (.moderator, .moderator):
            return true

        case (.photo, .photo):
            return true

        case (.dj, .dj):
            return true

        default:
            return false
        }
    }

    static var allTalents: [String] {
        return [
            Talent.moderator.description,
            Talent.dj.description,
            Talent.PhotoTalent.photo.rawValue,
            Talent.PhotoTalent.video.rawValue,
            Talent.PhotoTalent.photobox.rawValue,
            Talent.MusicTalent.piano.rawValue,
            Talent.MusicTalent.saxophone.rawValue
        ]
    }

    var description: String {
        switch self {
        case .moderator:
            return "Moderator"

        case .photo(let type):
            return type.rawValue

        case .music(let type):
            return type.rawValue

        case .dj:
            return "DJ"
        }
    }

    init(string: String) {
        switch string {
        case Talent.moderator.description:
            self = .moderator

        case Talent.dj.description:
            self = .dj

        case Talent.MusicTalent.piano.rawValue:
            self = .music(.piano)

        case Talent.MusicTalent.saxophone.rawValue:
            self = .music(.saxophone)

        case Talent.PhotoTalent.photobox.rawValue:
            self = .photo(.photobox)

        case Talent.PhotoTalent.photo.rawValue:
            self = .photo(.photo)

        case Talent.PhotoTalent.video.rawValue:
            self = .photo(.video)

        default:
            self = .dj
        }
    }
}

class Artist: User {
    var talent: Talent
    var description: String
    var country: String
    var price: Int

    var youtubeLinks = [String]()
    var feedbackLinks = [String]()

    var galleryPhotos = [UIImage]()
    var galleryPhotosLinks = [String]()
    var busyDates = [TimeInterval]()

    init(facebookId: String,
         name: String,
         talent: Talent,
         description: String,
         city: City,
         country: String,
         price: Int,
         photoLink: String
    ) {
        self.talent = talent
        self.description = description        
        self.country = country
        self.price = price
        super.init(type: .artist, facebookId: facebookId, name: name, city: city)
        self.photoLink = photoLink
    }

    static func instantiate(fromUser user: User) -> Artist {
        return Artist(
            facebookId: user.facebookId,
            name: user.name,
            talent: .dj,
            description: "Enter your description here",
            city: City.berlin,
            country: "Germany",
            price: 100,
            photoLink: user.photoLink ?? ""
        )
    }
}
