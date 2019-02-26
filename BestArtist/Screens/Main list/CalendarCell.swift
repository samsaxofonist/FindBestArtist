//
//  CalendarCell.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 26.02.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarCell: JTAppleCell {
    @IBOutlet weak var dateLabel: UILabel!
    
    static let cellSize: CGFloat = 50.0
    static let identifier = "CalendarCell"
}
