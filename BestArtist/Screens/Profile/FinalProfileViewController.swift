//
//  FinalProfileViewController.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 13.01.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FinalProfileViewController: WithoutTabbarViewController {
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var finalPriceLabel: UILabel!
    
    var disposeBag = DisposeBag()
    
    var city: City!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cityNameLabel.text = city.name
        priceTextField.rx.text.orEmpty
            .map {
                if let number = Int($0) {
                    return String(number * 2)
                } else {
                    return "Введите сумму"
                }
            }
            .bind(to: finalPriceLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
