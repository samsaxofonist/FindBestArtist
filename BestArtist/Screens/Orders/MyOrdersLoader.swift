//
//  MyOrdersLoader.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 15.10.20.
//  Copyright © 2020 kievkao. All rights reserved.
//

import Foundation

class MyOrdersLoader {

    func loadMyOrders(completion: (([Order]) -> Void)) {
        let artist = ArtistOrderInfo(artistId: "s", fixedPrice: 12)
        let orders = [
            Order(date: Date(), city: "Berlin", artists: [artist], isApproved: false),
            Order(date: Date(), city: "Berlin", artists: [artist], isApproved: false),
            Order(date: Date(), city: "Berlin", artists: [artist], isApproved: false),
            Order(date: Date(), city: "Berlin", artists: [artist], isApproved: false),
            Order(date: Date(), city: "Berlin", artists: [artist], isApproved: false)
        ]
        completion(orders)
    }
}
