//
//  Order.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 15.10.20.
//  Copyright © 2020 kievkao. All rights reserved.
//

import Foundation

struct Order {
    let date: Date
    let city: String
    let artists: [Artist]
    let totalPrice: Double
    let pricePerArtist: [String: Double]
    let isApproved: Bool
}
