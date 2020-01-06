//
//  MyProfileViewController+Price.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 12.07.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import Foundation

extension MyProfileViewController {
    func showPrice(_ price: Int?) {
        guard let price = self.artist?.price else { return }
        self.selectedPrice = price
        let priceToDisplay = String(price) + "€"
        self.priceButton.setTitle(priceToDisplay, for: .normal)
    }
    
    func setupPriceController(_ controller: SelectPriceViewController) {
        guard let artist = self.artist else { return }
        controller.currentPrice = artist.price
        controller.fromCity = artist.city
        controller.finishBlock = { price in
            self.showPrice(price)
        }
    }
}
