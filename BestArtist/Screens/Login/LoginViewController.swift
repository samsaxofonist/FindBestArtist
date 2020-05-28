//
//  LoginViewController.swift
//  FindBestArtist
//
//  Created by Andrii Kravchenko on 11.10.18.
//  Copyright © 2018 Samus Dimitrij. All rights reserved.
//

import UIKit
import ARSLineProgress
import FBSDKLoginKit

final class LoginViewController: BaseViewController {

    @IBOutlet var viewToHideAndShow: [UIView]!
    var userType: UserType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyTheme(theme: ThemeManager.theme)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        setEverythingVisible(isVisible: false)
        
        LoginManager.login(fromViewController: self, progressStartBlock: {
            ARSLineProgress.show()            
        }, completion: { fbProfile, existedArtist in
            if let profile = fbProfile {
                self.processSuccessLogin(fbProfile: profile, existedArtist: existedArtist)
            } else {
                self.setEverythingVisible(isVisible: true)
            }
        })
    }

    func processSuccessLogin(fbProfile: FBSDKProfile, existedArtist: User?) {
        ARSLineProgress.hide()
        GlobalManager.fbProfile = fbProfile
        switch self.userType {
        case .artist:
            GlobalManager.myUser = Artist.instantiate(fromUser: User(facebookId: fbProfile.userID, name: fbProfile.name))

            if existedArtist != nil {
                self.openMainScreen()
            } else {
                self.openCreateProfile(fbProfile: fbProfile)
            }
        case .customer:
            GlobalManager.myUser = User(facebookId: fbProfile.userID, name: fbProfile.name)
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

    func openCreateProfile(fbProfile: FBSDKProfile) {
        guard let user = GlobalManager.myUser else { return }
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileVC = profileStoryboard.instantiateViewController(withIdentifier: "NewProfile") as! MyProfileViewController
        profileVC.artist = Artist.instantiate(fromUser: user)
        profileVC.isNewProfile = true
        self.navigationController?.setViewControllers([profileVC], animated: false)
    }
    
    func openMainScreen() {
        let mainTabBar = self.storyboard!.instantiateViewController(withIdentifier: "MainTabBarController")
        self.navigationController?.setViewControllers([mainTabBar], animated: true)
    }
    
    func applyTheme(theme: Theme) {
        // TODO
    }
}
