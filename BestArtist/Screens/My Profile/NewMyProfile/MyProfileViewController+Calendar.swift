//
//  MyProfileViewController+Calendar.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 24.07.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit
import KDCalendar

extension MyProfileViewController: CalendarViewDataSource, CalendarViewDelegate {
    func setupCalendar() {
        calendarView.marksWeekends = true
        calendarView.dataSource = self
        calendarView.delegate = self
    }
    
    func selectCalendarDates() {
        guard let artist = self.artist else { return }
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

    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
        selectedDates.append(date.timeIntervalSince1970)
    }

    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) {
        if let index = selectedDates.firstIndex(of: date.timeIntervalSince1970) {
            selectedDates.remove(at: index)
        }
    }

    func calendar(_ calendar: CalendarView, didScrollToMonth date: Date) {}
    func calendar(_ calendar: CalendarView, canSelectDate date: Date) -> Bool { return true }
    func calendar(_ calendar: CalendarView, didLongPressDate date: Date) {}
}

class CalendarDecorator {

    static func decorateCalendar() {
        CalendarView.Style.cellShape                = .bevel(4.0)
        CalendarView.Style.cellEventColor = UIColor.brown
        CalendarView.Style.cellTextColorWeekend = UIColor(red:1.00, green:0.63, blue:0.24, alpha:1.00)
        CalendarView.Style.cellSelectedBorderColor  = UIColor(red:89/255, green:254/255, blue:254/255, alpha:1.00)
        CalendarView.Style.headerTextColor          = ThemeManager.theme.darkColor
    }
}
