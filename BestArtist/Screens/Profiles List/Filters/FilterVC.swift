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

class FilterVC: UIViewController, RangeSeekSliderDelegate {
    
    @IBOutlet weak var priceSlider: RangeSeekSlider!
    @IBOutlet weak var countriesPicker: UIPickerView!
    @IBOutlet weak var mapView: MKMapView!

    var filterChangedBlock: (() -> ())!
    var artists: [Artist]!
    var countries = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyTheme(theme: ThemeManager.theme)
        priceSlider.delegate = self
        setInitialFilterValues()
        readCountriesFromFile()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selectMyCountry()
    }
    
    func applyTheme(theme: Theme) {
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
        let lowValue = Int(slider.selectedMinValue)
        let highValue = Int(slider.selectedMaxValue)
        
        GlobalManager.filterPrice = .price(from: lowValue, up: highValue)
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
