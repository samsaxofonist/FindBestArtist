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
    var needGradient: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if needGradient == true {
            self.view.drawGradient()
        }
    }

}

class BaseTableViewController: UITableViewController {
    
    var needTabBar: Bool = false
    var needGradient: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if needGradient == true {
            self.view.drawGradient()
        }
    }


}

