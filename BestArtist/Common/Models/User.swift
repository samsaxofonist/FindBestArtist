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
        self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

enum Talent {
    case music(MusicTalent)
    case moderator(ModeratorTalent)
    case photo(PhotoTalent)
    case other(String)

    enum MusicTalent: String {
        case piano = "Piano"
        case saxophone = "Saxophone"
        case dj = "DJ"
    }

    enum PhotoTalent: String {
        case photo = "Photograph"
        case video = "Videograph"
        case photobox = "Photobox"
    }

    enum ModeratorTalent: String {
        case moderator = "Moderator"
    }

    static var allTalents: [String] {
        return [
            Talent.ModeratorTalent.moderator.rawValue,
            Talent.MusicTalent.dj.rawValue,
            Talent.PhotoTalent.photo.rawValue,
            Talent.PhotoTalent.video.rawValue,
            Talent.PhotoTalent.photobox.rawValue,
            Talent.MusicTalent.piano.rawValue,
            Talent.MusicTalent.saxophone.rawValue,
            "Other"
        ]
    }

    var description: String {
        switch self {
        case .moderator(let type):
            return type.rawValue

        case .photo(let type):
            return type.rawValue

        case .music(let type):
            return type.rawValue

        case .other(let value):
            return value
        }
    }

    init(string: String) {
        switch string {
        case Talent.ModeratorTalent.moderator.rawValue:
            self = .moderator(.moderator)

        case Talent.MusicTalent.dj.rawValue:
            self = .music(.dj)

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
            self = .other(string)
        }
    }
}

class Artist: User {
    var talent: Talent
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
         talent: Talent,
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

    static func instantiate(fromUser user: User) -> Artist {
        return Artist(
            facebookId: user.facebookId,
            name: user.name,
            talent: .music(.dj),
            description: "Enter your description here",
            city: City.berlin,
            country: "Germany",
            price: 100,
            photoLink: user.photoLink ?? ""
        )
    }
}
