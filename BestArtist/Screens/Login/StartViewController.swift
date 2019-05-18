//
//  StartViewController.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 18.05.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        GlobalManager.rootNavigation = self.navigationController
        
        if LoginManager.isLoggedIn {
            openMainScreen()
        } else {
            openLoginScreen()
        }
    }
    
    private func openLoginScreen() {
        let login = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
        self.navigationController?.setViewControllers([login], animated: false)
    }
    
    private func openMainScreen() {
        let mainTabBar = self.storyboard!.instantiateViewController(withIdentifier: "MainTabBarController")
        self.navigationController?.setViewControllers([mainTabBar], animated: false)
    }
}
