//
//  Order.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 15.10.20.
//  Copyright © 2020 kievkao. All rights reserved.
//

import Foundation

struct ArtistOrderInfo {
    let artistId: String
    let fixedPrice: Int

    func convertToSimpleData() -> [String: Int] {
        return [artistId: fixedPrice]
    }
}

struct Order {
    let date: Date
    let city: String
    let artists: [ArtistOrderInfo]
    let isApproved: Bool

    func getSimpleArtists() -> [[String: Int]] {
        return artists.map { $0.convertToSimpleData() }
    }
}
