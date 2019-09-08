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

        applyTheme(theme: ThemeManager.theme)
        GlobalManager.rootNavigation = self.navigationController
        let profile = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "NewProfile") as! MyProfileViewController
        profile.artist = Artist()
        self.navigationController?.setViewControllers([profile], animated: false)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            if LoginManager.isLoggedIn {
//                self.openMainScreen()
//            } else {
//                self.openLoginScreen()
//            }
//        }
    }
    
    private func openLoginScreen() {
        let login = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
        self.navigationController?.setViewControllers([login], animated: false)
    }
    
    private func openMainScreen() {
        let mainTabBar = self.storyboard!.instantiateViewController(withIdentifier: "MainTabBarController")
        self.navigationController?.setViewControllers([mainTabBar], animated: false)
    }
    
    func applyTheme(theme: Theme) {
    }
}
