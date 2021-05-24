//
//  EventDateSelectionViewController.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 24.05.21.
//  Copyright © 2021 kievkao. All rights reserved.
//

import UIKit
import KDCalendar

class EventDateSelectionViewController: UIViewController, CalendarViewDataSource, CalendarViewDelegate {
    @IBOutlet weak var selectedCityLabel: UILabel!
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var selectCityButton: UIButton!
    @IBOutlet weak var selectDateLabel: UILabel!
    
    var selectedDates = [TimeInterval]()
    var selectedCity: City?
    var selectedCountry: String?
    var userType: UserType!
    
    var finishBlock: (([TimeInterval], City, String) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userType == .artist {
            selectedCityLabel.text = "Your city"
            selectDateLabel.text = "Select your busy dates"
        } else {
            selectedCityLabel.text = "City of your event"
            selectDateLabel.text = "Select possible dates"
        }
            
        setupCalendar()
    }
    
    func setupCalendar() {
        CalendarDecorator.decorateCalendar()
        calendarView.marksWeekends = true
        calendarView.dataSource = self
        calendarView.delegate = self
    }
    
    @IBAction func selectCityButtonClicked() {
        let cityNavController = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "citySelectionNavigation") as! UINavigationController
        let cityVC = cityNavController.viewControllers.first as! SelectCityViewController
        setupCityController(cityVC)
        self.present(cityNavController, animated: true, completion: nil)
    }
    
    @IBAction func continueButtonClicked() {
        if let city = selectedCity, let country = selectedCountry {
            finishBlock(selectedDates, city, country)
            self.navigationController?.popViewController(animated: true)
        } else {
            let errorAlert = UIAlertController(title: "Error", message: "Select city!", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(errorAlert, animated: true, completion: nil)
        }
    }
    
    func setupCityController(_ controller: SelectCityViewController) {
        controller.finishBlock = { city, country in
            self.selectedCity = city
            self.selectedCountry = country
            self.selectedCityLabel.text = city.name
        }
    }
    
    func startDate() -> Date {
        return Date()
    }
    
    func endDate() -> Date {
        return Calendar.current.date(byAdding: .year, value: 3, to: Date())!
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
    func calendar(_ calendar: CalendarView, canSelectDate date: Date) -> Bool {
        return true
    }
    func calendar(_ calendar: CalendarView, didLongPressDate date: Date) {}
}
