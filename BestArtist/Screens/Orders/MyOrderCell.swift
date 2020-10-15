//
//  MyOrderCell.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 15.10.20.
//  Copyright © 2020 kievkao. All rights reserved.
//

import UIKit

class MyOrderCell: UITableViewCell {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        return formatter
    }()
    
    func setupWithOrder(_ order: Order) {
        priceLabel.text = String(order.totalPrice) + "€"
        dateLabel.text = MyOrderCell.dateFormatter.string(from: order.date)
    }
}
