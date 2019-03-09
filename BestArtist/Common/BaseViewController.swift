//
//  BaseViewController.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 16.12.18.
//  Copyright © 2018 kievkao. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var needTabBar: Bool = false
    var needGradient: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if needGradient == true {
            self.view.drawGradient()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if needTabBar == false {
            self.tabBarController?.tabBar.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
