//
//  SetUserDatesVC.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 05.03.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit
import ARSLineProgress
import KDCalendar

class SetUserDatesVC: BaseViewController {

    @IBOutlet weak var calendar: CalendarView!
    var artist: User!
    var selectedDates = [TimeInterval]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewComponents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let today = Date()
        self.calendar.setDisplayDate(today, animated: false)
        for timeInterval in artist.busyDates {
            calendar.selectDate(Date(timeIntervalSince1970: timeInterval))
        }
    }
    
    func setupViewComponents() {
        calendar.marksWeekends = true
        calendar.dataSource = self
        calendar.delegate = self
    }
 
    @IBAction func saveAllButton(_ sender: Any) {
        ARSLineProgress.show()
        artist.busyDates = selectedDates
        NetworkManager.saveArtist(artist, finish: {
            ARSLineProgress.hide()
            NotificationCenter.default.post(name: .refreshNamesList, object: nil)
            self.navigationController?.popToRootViewController(animated: true)
        })
    }
}

extension SetUserDatesVC: CalendarViewDataSource, CalendarViewDelegate {
    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
        selectedDates.append(date.timeIntervalSince1970)
    }
    
    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) {
        if let index = selectedDates.firstIndex(of: date.timeIntervalSince1970) {
            selectedDates.remove(at: index)
        }
    }
    
    func startDate() -> Date {
        return Date()
    }
    
    func endDate() -> Date {
        return Calendar.current.date(byAdding: .year, value: 2, to: Date())!
    }
    
    func calendar(_ calendar: CalendarView, didScrollToMonth date: Date) {}
    func calendar(_ calendar: CalendarView, canSelectDate date: Date) -> Bool { return true }
    func calendar(_ calendar: CalendarView, didLongPressDate date: Date) {}
}
