//
//  LoginViewController.swift
//  FindBestArtist
//
//  Created by Andrii Kravchenko on 11.10.18.
//  Copyright © 2018 Samus Dimitrij. All rights reserved.
//

import UIKit
import ARSLineProgress

class LoginViewController: BaseViewController {

    @IBOutlet var viewToHideAndShow: [UIView]!
    var userType: UserType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyTheme(theme: ThemeManager.theme)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        setEverythingVisible(isVisible: false)
        
        LoginManager.login(fromViewController: self, progressStartBlock: {
            ARSLineProgress.show()            
        }, completion: { isOK in
            if isOK {
                self.processSuccessLogin()
            } else {
                self.setEverythingVisible(isVisible: true)
            }
        })
    }

    func processSuccessLogin() {
        
        switch self.userType {
        case .artist:
            self.openCreateProfile()
        case .customer:
            self.openMainScreen()
        case .none:
            break
        }
    }
    
    func setEverythingVisible(isVisible: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            ARSLineProgress.hide()
            self.viewToHideAndShow.forEach { $0.isHidden = !isVisible }
        }
    }

    func openCreateProfile() {
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileVC = profileStoryboard.instantiateViewController(withIdentifier: "NewProfile") as! MyProfileViewController
        self.navigationController?.setViewControllers([profileVC], animated: true)
        ARSLineProgress.hide()
    }
    
    func openMainScreen() {
        let mainTabBar = self.storyboard!.instantiateViewController(withIdentifier: "MainTabBarController")        
        self.navigationController?.setViewControllers([mainTabBar], animated: true)
        ARSLineProgress.hide()
    }
    
    func applyTheme(theme: Theme) {
    }
}
