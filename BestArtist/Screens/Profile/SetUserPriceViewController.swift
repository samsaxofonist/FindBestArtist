//
//  SetUserPriceViewController.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 13.01.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation
import ARSLineProgress

class SetUserPriceViewController: BaseViewController {
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var finalPriceLabel: UILabel!
    
    var disposeBag = DisposeBag()
    let berlin = City(name: "Berlin", location: CLLocationCoordinate2D(latitude: 52.520008, longitude: 13.404954))
    let hamburg = City(name: "Hamburg", location: CLLocationCoordinate2D(latitude: 53.551086, longitude: 9.993682))    
    var artist: Artist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        setupDistance()
    }
    
    func setupDistance() {
        var distance: Double
        
        if artist.city! == berlin {
            distance = hamburg.location.distance(from: artist.city!.location)
            cityNameLabel.text = "Hamburg"
        } else {
            distance = berlin.location.distance(from: artist.city!.location)
            cityNameLabel.text = "Berlin"
        }
        distance = distance/1000
        
        setupPrice(withDistance: distance)
    }
    
    func setupPrice(withDistance distance: Double) {
        priceTextField.rx.text.orEmpty
            .map {
                if let price = Double($0) {
                    let result: Double = ceil(price + (distance/2))
                    return String(result)
                } else {
                    return ""
                }
            }
            .bind(to: finalPriceLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextViewController = segue.destination as! SetUserDatesVC
        artist.price = Int(priceTextField.text ?? "") ?? 0
        nextViewController.artist = artist
    }
    
    
}

extension CLLocationCoordinate2D {
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let destination = CLLocation(latitude:from.latitude, longitude:from.longitude)
        return CLLocation(latitude: self.latitude, longitude: self.longitude).distance(from: destination)
    }
}

extension Notification.Name {
    static let refreshNamesList = Notification.Name("refreshNamesList")
}
