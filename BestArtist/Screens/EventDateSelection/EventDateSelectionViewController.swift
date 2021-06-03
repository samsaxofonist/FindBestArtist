//
//  EventDateSelectionViewController.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 24.05.21.
//  Copyright © 2021 kievkao. All rights reserved.
//

import UIKit
import KDCalendar
import ARSLineProgress
import VisualEffectView

class EventDateSelectionViewController: UIViewController, CalendarViewDataSource, CalendarViewDelegate {
    @IBOutlet weak var selectedCityLabel: UILabel!
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var selectCityButton: UIButton!
    @IBOutlet weak var selectDateLabel: UILabel!
    @IBOutlet weak var continueButton: HelpUIButtonClass!
    
    var selectedDates = [TimeInterval]()
    var selectedCity: City?
    var selectedCountry: String?
    var userType: UserType!
    
    var blur: VisualEffectView!
    
    var finishBlock: (([TimeInterval], City, String) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userType == .artist {
            selectedCityLabel.text = "Your city"
            selectDateLabel.text = "Your busy dates"
        } else {
            selectedCityLabel.text = "City of event"
            selectDateLabel.text = "Date of event"
        }
        
        if let city = GlobalManager.myUser?.city {
            selectedCity = city
            selectedCityLabel.text = city.name
            selectedCountry = GlobalManager.myUser?.country
            
            continueButton.isHidden = true
        }
        setupBlur()
        setupCalendar()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveClicked))
    }
    
    func setupBlur() {
        blur = VisualEffectView(frame: self.view.frame)
        blur.colorTint = .white
        blur.colorTintAlpha = 0.2
        blur.blurRadius = 7
        self.view.addSubview(blur)
        blur.isHidden = true
    }
    
    func setBlurVisible(_ visible: Bool) {
        blur.isHidden = !visible
    }
    
    @objc func saveClicked() {
        
        if let newCity = selectedCity {
            GlobalManager.myUser?.city = newCity
            NotificationCenter.default.post(name: .refreshNamesList, object: nil)
        }

        if let newCountry = selectedCountry {
            GlobalManager.myUser?.country = newCountry
        }
        
        GlobalManager.myUser?.dates = selectedDates

        setBlurVisible(true)
        NetworkManager.saveCustomer(GlobalManager.myUser!) {
            ARSLineProgress.showSuccess()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.setBlurVisible(false)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let dates = GlobalManager.myUser?.dates {
            selectedDates = dates
            for timeInterval in dates {
                calendarView.selectDate(Date(timeIntervalSince1970: timeInterval))
            }
        }
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
