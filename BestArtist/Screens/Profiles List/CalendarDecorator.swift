//
//  CalendarDecorator.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 24.07.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit
import KDCalendar

class CalendarDecorator {
    
    static func decorateCalendar() {
        CalendarView.Style.cellShape                = .bevel(4.0)
        CalendarView.Style.cellEventColor = UIColor.brown
        CalendarView.Style.cellTextColorWeekend = UIColor(red:1.00, green:0.63, blue:0.24, alpha:1.00)
        CalendarView.Style.cellSelectedBorderColor  = UIColor(red:89/255, green:254/255, blue:254/255, alpha:1.00)
        CalendarView.Style.headerTextColor          = UIColor.white
    }
}
