//
//  FilterVC.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 22.05.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit
import RangeSeekSlider
import MapKit

class FilterVC: UIViewController, RangeSeekSliderDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var priceSlider: RangeSeekSlider!
    @IBOutlet weak var distanceSlider: RangeSeekSlider!
    @IBOutlet weak var countriesPicker: UIPickerView!
    @IBOutlet weak var mapView: MKMapView!

    var filterChangedBlock: (() -> ())!
    var artists: [Artist]!
    var countries = [String]()

    let zoneCircleRadius: Double = 125
    var userLocationIsTaken = false

    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyTheme(theme: ThemeManager.theme)
        priceSlider.delegate = self
        distanceSlider.delegate = self
        setInitialFilterValues()
        setupLocationManager()
        readCountriesFromFile()
        addArtistsOnMap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selectMyCountry()
    }
    
    func applyTheme(theme: Theme) {
    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers

        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard userLocationIsTaken == false else { return }
        guard let latestLocation = locations.first else { return }
        let regionRadius: CLLocationDistance = 100000
        let region = MKCoordinateRegion(center: latestLocation.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
        userLocationIsTaken = true
    }

    func addArtistsOnMap() {
        // Взять массив координат каждого артиста
        let usersLocations: [CLLocationCoordinate2D] = artists.map { $0.city.location }
        // Взять только уникальные координаты, которые не повторяются
        let uniqueLocations = Set<CLLocationCoordinate2D>(usersLocations)

        for location in uniqueLocations {
            let numberOfUsers = artists.filter { $0.city.location == location }.count

            let annotaion = MKPointAnnotation()
            annotaion.title = "\(numberOfUsers) artists"
            annotaion.coordinate = location
            mapView.addAnnotation(annotaion)
        }
    }
    
    func readCountriesFromFile() {
        let url = Bundle.main.url(forResource: "CountriesList", withExtension: "json")!
        let jsonData = try! Data(contentsOf: url)
        let json = try! JSONSerialization.jsonObject(with: jsonData) as! [[String: Any]]
        
        for countryDict in json {
            let name = countryDict["name"] as! String
            countries.append(name)
        }
        
        countries.sort()
    }
    
    func selectMyCountry() {
        if let artist = GlobalManager.myUser as? Artist, let index = countries.index(of: artist.country) {
            countriesPicker.selectRow(index, inComponent: 0, animated: true)
        }
    }
    
    func setInitialFilterValues() {
        let allPrices = artists.map { $0.price }
        let minPrice = allPrices.min()!
        let maxPrice = allPrices.max()!

        priceSlider.minValue = CGFloat(minPrice)
        priceSlider.maxValue = CGFloat(maxPrice)
        priceSlider.selectedMinValue = CGFloat(minPrice)
        priceSlider.selectedMaxValue = CGFloat(maxPrice)

        if let filter = GlobalManager.filterPrice {
            if case let FilterType.price(from, up) = filter {
                priceSlider.selectedMinValue = CGFloat(from)
                priceSlider.selectedMaxValue = CGFloat(up)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let rootNavC = segue.destination as! UINavigationController
        let mapVC = rootNavC.viewControllers.first as! MapVC
        mapVC.allArtists = artists
    }
    
    @IBAction func countryButtonClicked(_ sender: Any) {
    }
    
    @IBAction func applyButtonClicked(_ sender: Any) {
        filterChangedBlock()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider == self.priceSlider {
            let lowValue = Int(slider.selectedMinValue)
            let highValue = Int(slider.selectedMaxValue)

            GlobalManager.filterPrice = .price(from: lowValue, up: highValue)
        } else {
            
        }
    }
}

extension FilterVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row]
    }
}
