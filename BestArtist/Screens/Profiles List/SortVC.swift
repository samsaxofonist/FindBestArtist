//
//  Sort.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 19.03.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit

class SortVC: UIViewController {
    @IBOutlet weak var sortListView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sortSwitch: UISwitch!
    
    var sortingChangedBlock: (() -> ())!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sortListView.layer.cornerRadius = 10
        
        titleLabel.text = GlobalManager.sorting.title
        if GlobalManager.sorting == .lowToHigh {
            sortSwitch.isOn = true
        } else {
            sortSwitch.isOn = false
        }
    }
    
    @IBAction func backgroundClicked(_ sender: Any) {
        sortingChangedBlock()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sortingChanged(_ sender: UISwitch) {
        if sender.isOn {
            GlobalManager.sorting = .lowToHigh
        } else {
            GlobalManager.sorting = .highToLow
        }
        titleLabel.text = GlobalManager.sorting.title
    }
    
    func blurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sortListView.addSubview(blurEffectView)
    }
}
