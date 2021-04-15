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
import ARSLineProgress

class FilterVC: UIViewController, RangeSeekSliderDelegate {
    
    @IBOutlet weak var priceSlider: RangeSeekSlider!
    @IBOutlet weak var distanceSlider: RangeSeekSlider!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var filtersContainer: UIView!

    var filterChangedBlock: (() -> ())!
    var artists: [Artist]!
    var radiusM: CLLocationDistance = 500000

    let zoneCircleRadius: Double = 125

    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyTheme(theme: ThemeManager.theme)
        filtersContainer.layer.cornerRadius = 25

        priceSlider.delegate = self
        priceSlider.numberFormatter.positiveSuffix = "€"
        
        distanceSlider.delegate = self
        setInitialFilterValues()
        addArtistsOnMap()
        moveMapToUsersCity()
    }

    func moveMapToUsersCity() {
        if let city = GlobalManager.myUser?.city {
            moveMap(location: city.location)
        }
    }

    func applyTheme(theme: Theme) {
    }

    func moveMap(location: CLLocationCoordinate2D) {
        let regionRadius: CLLocationDistance = radiusM * 2
        let region = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
    }

    func addArtistsOnMap() {
        // Взять массив координат каждого артиста
        let usersLocations: [CLLocationCoordinate2D] = artists.map { $0.city.location }
        // Взять только уникальные координаты, которые не повторяются
        let uniqueLocations = Set<CLLocationCoordinate2D>(usersLocations)

        // проходим по каждой уникальной локации
        for location in uniqueLocations {
            let annotaion = MKPointAnnotation()
            annotaion.coordinate = location
            mapView.addAnnotation(annotaion)
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

        if let distanceFilter = GlobalManager.filterDistance {
            if case let FilterType.distance(_, radius) = distanceFilter {
                distanceSlider.selectedMaxValue = CGFloat(radius / 1000)
                radiusM = radius
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let rootNavC = segue.destination as! UINavigationController
        let mapVC = rootNavC.viewControllers.first as! MapVC
        mapVC.allArtists = artists
    }
    
    @IBAction func changeCityButtonClicked(_ sender: Any) {
        let cityController = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(identifier: "citySelectionVC") as! SelectCityViewController
        setupCityController(cityController)
        self.navigationController?.present(cityController, animated: true, completion: nil)
    }

    func setupCityController(_ controller: SelectCityViewController) {
        controller.finishBlock = { [weak self] city, country in
            self?.updateUsersCityIfNeeded(city: city, country: country)
            self?.moveMap(location: city.location)
            self?.updateRadiusFilter(for: city)
        }
    }

    func updateRadiusFilter(for city: City) {
        GlobalManager.filterDistance = .distance(center: city.location, radius: radiusM)
        GlobalManager.myUser?.city = city
    }

    func updateUsersCityIfNeeded(city: City, country: String) {
        if GlobalManager.myUser is Artist {
            return
        }

        ARSLineProgress.show()
        NetworkManager.saveCustomer(GlobalManager.myUser!) {
            ARSLineProgress.hide()
        }
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
            // вызывать только при остановке слайдера
            radiusM = Double(maxValue * 1000)
            let regionRadius: CLLocationDistance = radiusM * 2
            let oldRegion = mapView.region

            let newRegion = MKCoordinateRegion(center: oldRegion.center, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            mapView.setRegion(newRegion, animated: true)
        }
    }

    func rangeSeekSlider(_ slider: RangeSeekSlider, stringForMaxValue: CGFloat) -> String? {
        if slider == self.distanceSlider {
            if stringForMaxValue == slider.maxValue {
                return String(format: ">%.0f", stringForMaxValue)
            } else {
                return String(format: "%.0f", stringForMaxValue)
            }
        } else {
            return String(format: "%.0f€", stringForMaxValue)
        }
    }

}

