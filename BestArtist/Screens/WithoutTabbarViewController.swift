//
//  WithoutTabbarViewController.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 16.12.18.
//  Copyright © 2018 kievkao. All rights reserved.
//

import UIKit

class WithoutTabbarViewController: UIViewController {

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.tabBarController?.tabBar.isHidden = true
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            self.tabBarController?.tabBar.isHidden = false
        }
}
