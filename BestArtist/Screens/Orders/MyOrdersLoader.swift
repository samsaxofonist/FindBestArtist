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
        let artist = Artist.instantiate(fromUser: GlobalManager.myUser!)
        let orders = [
            Order(date: Date(), city: "Berlin", artists: [artist], totalPrice: 1000, pricePerArtist: [artist.facebookId: 500], isApproved: false),
            Order(date: Date(), city: "Berlin", artists: [artist], totalPrice: 1000, pricePerArtist: [artist.facebookId: 500], isApproved: false),
            Order(date: Date(), city: "Berlin", artists: [artist], totalPrice: 1000, pricePerArtist: [artist.facebookId: 500], isApproved: false),
            Order(date: Date(), city: "Berlin", artists: [artist], totalPrice: 1000, pricePerArtist: [artist.facebookId: 500], isApproved: false),
            Order(date: Date(), city: "Berlin", artists: [artist], totalPrice: 1000, pricePerArtist: [artist.facebookId: 500], isApproved: false)
        ]
        completion(orders)
    }
}
