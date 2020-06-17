//
//  RootViewController.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 17.06.20.
//  Copyright © 2020 kievkao. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    @IBOutlet weak var tabBar: UIView!

    var embeddedTabBarController: UITabBarController!

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.layer.cornerRadius = 16
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.embeddedTabBarController = segue.destination as! UITabBarController
        embeddedTabBarController.tabBar.isHidden = true
    }

    @IBAction func djTabSelected() {
        embeddedTabBarController.selectedIndex = 0
    }

    @IBAction func musiciansTabSelected() {
        embeddedTabBarController.selectedIndex = 1
    }

    @IBAction func moderatorsTabSelected() {
        embeddedTabBarController.selectedIndex = 2
    }

    @IBAction func videosTabSelected() {
        embeddedTabBarController.selectedIndex = 3
    }

}
