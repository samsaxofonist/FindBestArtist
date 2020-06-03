//
//  PriceCalculator.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 03.06.20.
//  Copyright © 2020 kievkao. All rights reserved.
//

import Foundation

class PriceCalculator {

    static func adjustedPriceFrom(initialPrice: Double, distanceBetweenCities: Double) -> Double {
        let distance = distanceBetweenCities / 1000
        return ceil(initialPrice + (distance/2))
    }
}
