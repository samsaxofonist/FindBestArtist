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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.drawGradient()
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
