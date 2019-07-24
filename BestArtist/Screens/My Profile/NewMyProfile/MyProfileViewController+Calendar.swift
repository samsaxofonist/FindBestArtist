//
//  MyProfileViewController+Calendar.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 24.07.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit
import KDCalendar

extension MyProfileViewController: CalendarViewDataSource {
    func setupCalendar() {
        calendarView.marksWeekends = true
        calendarView.dataSource = self
    }
    
    func selectCalendarDates() {
        calendarView.setDisplayDate(Date(), animated: false)
        for timeInterval in artist.busyDates {
            calendarView.selectDate(Date(timeIntervalSince1970: timeInterval))
        }
    }
    
    func startDate() -> Date {
        return Date()
    }
    
    func endDate() -> Date {
        return Calendar.current.date(byAdding: .year, value: 2, to: Date())!
    }
}
