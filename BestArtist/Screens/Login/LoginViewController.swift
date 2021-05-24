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

final class LoginViewController: InitialSetupViewController {

    @IBOutlet var viewToHideAndShow: [UIView]!    
    
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
        
        AppLoginManager.login(fromViewController: self, progressStartBlock: {
            ARSLineProgress.show()            
        }, completion: { fbProfile, existedArtist in
            if let profile = fbProfile {
                self.processSuccessLogin(fbProfile: profile, existedArtist: existedArtist)
            } else {
                self.setEverythingVisible(isVisible: true)
            }
        })
    }

    func processSuccessLogin(fbProfile: Profile, existedArtist: User?) {
        ARSLineProgress.hide()
        GlobalManager.fbProfile = fbProfile

        if let user = existedArtist {
            finishLogin(fbProfile: fbProfile, existedArtist: user, city: user.city, country: user.country)
        } else {
            openEventDateScreen(fbProfile: fbProfile)
        }
    }

    func setEverythingVisible(isVisible: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            ARSLineProgress.hide()
            self.viewToHideAndShow.forEach { $0.isHidden = !isVisible }
        }
    }

        
    func applyTheme(theme: Theme) {
        // TODO
    }
}
