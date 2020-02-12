//
//  StartViewController.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 18.05.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit
import FBSDKLoginKit

final class StartViewController: UIViewController {
    @IBOutlet weak var beKunstlerButton: UIButton!
    @IBOutlet weak var buchenArtistButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.checkLogin()
    }

    func setup() {
        applyTheme(theme: ThemeManager.theme)
        GlobalManager.rootNavigation = self.navigationController
    }

    func checkLogin() {
        if LoginManager.hasUser {
            LoginManager.loginWithSavedUser { (fbProfile, user) in
                GlobalManager.fbProfile = fbProfile
                GlobalManager.myUser = user
                self.openMainScreen()
            }
        } else {
            self.beKunstlerButton.isHidden = false
            self.buchenArtistButton.isHidden = false
        }
    }
    
    private func openLoginScreen(userType: UserType) {
        let login: LoginViewController = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        login.userType = userType
        self.navigationController?.setViewControllers([login], animated: false)
    }
    
    private func openMainScreen() {
        let mainTabBar = self.storyboard!.instantiateViewController(withIdentifier: "MainTabBarController")
        self.navigationController?.setViewControllers([mainTabBar], animated: false)
    }
    
    func applyTheme(theme: Theme) {
        // TODO
    }

    @IBAction func beKunstlerClicked(_ sender: Any) {
        self.openLoginScreen(userType: .artist)
    }

    @IBAction func buchenArtistClicked(_ sender: Any) {
        self.openLoginScreen(userType: .customer)
    }
}
