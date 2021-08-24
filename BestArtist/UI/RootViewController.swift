//
//  RootViewController.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 17.06.20.
//  Copyright © 2020 kievkao. All rights reserved.
//

import UIKit

// Test
class RootViewController: UIViewController {
    @IBOutlet weak var tabBar: UIView!
    @IBOutlet weak var tabBarContainer: UIView!

    var embeddedTabBarController: UITabBarController!
    
    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [
            UIColor.white.withAlphaComponent(0).cgColor,
            UIColor.white.withAlphaComponent(1).cgColor
        ]
        gradient.locations = [0.2, 1]
        return gradient
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(contentControllerAppears), name: Notification.Name("NeedShowTabBar"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(contentControllerDisappears), name: Notification.Name("NeedHideTabBar"), object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradient.frame = tabBarContainer.bounds
        tabBarContainer.layer.insertSublayer(gradient, at: 0)
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
