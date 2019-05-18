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
    @IBOutlet weak var upButton: HelpUIButtonClass!
    @IBOutlet weak var downButton: HelpUIButtonClass!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sortListView.layer.cornerRadius = 10

    }
    
    @IBAction func backgroundClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func blurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sortListView.addSubview(blurEffectView)
    }
}
