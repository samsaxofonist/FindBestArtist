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
    @IBOutlet weak var tabBarContainer: UIView!

    var embeddedTabBarController: UITabBarController!

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.layer.cornerRadius = 16

        NotificationCenter.default.addObserver(self, selector: #selector(contentControllerAppears), name: Notification.Name("ProfilesListAppears"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(contentControllerDisappears), name: Notification.Name("ProfilesListDisappears"), object: nil)
    }

    @objc func contentControllerAppears() {
        tabBarContainer.isHidden = false
    }

    @objc func contentControllerDisappears() {
        tabBarContainer.isHidden = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.embeddedTabBarController = segue.destination as? UITabBarController
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
