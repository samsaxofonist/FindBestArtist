//
//  FilterVC.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 22.05.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit
import RangeSeekSlider

class FilterVC: UIViewController, RangeSeekSliderDelegate {
    
    @IBOutlet weak var priceSlider: RangeSeekSlider!
    
    var filterChangedBlock: (() -> ())!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        priceSlider.delegate = self
        
        if let filter = GlobalManager.filter {
            if case let FilterType.price(from, up) = filter {
                priceSlider.selectedMinValue = CGFloat(from)
                priceSlider.selectedMaxValue = CGFloat(up)
            }
        }
    }
    
    @IBAction func backgroundClicked(_ sender: Any) {
        filterChangedBlock()
        self.dismiss(animated: true, completion: nil)
    }
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        let lowValue = Int(slider.selectedMinValue)
        let highValue = Int(slider.selectedMaxValue)
        
        GlobalManager.filter = .price(from: lowValue, up: highValue)
    }

}
