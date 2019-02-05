//
//  LoginViewController.swift
//  FindBestArtist
//
//  Created by Andrii Kravchenko on 11.10.18.
//  Copyright © 2018 Samus Dimitrij. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import ARSLineProgress


class LoginViewController: BaseViewController {

    @IBOutlet var viewToHideAndShow: [UIView]!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        GlobalManager.rootNavigation = self.navigationController
        
        if FBSDKAccessToken.current() != nil {
            ARSLineProgress.hide()
            openMainScreen()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        setEverythingVisible(isVisible: false)
        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            guard error == nil, let token = FBSDKAccessToken.current() else {
                self.setEverythingVisible(isVisible: true)
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
            Auth.auth().signInAndRetrieveData(with: credential, completion: { (result, error) in
                guard error == nil else {
                    self.setEverythingVisible(isVisible: true)
                    return
                }
                self.openMainScreen()
            })
        }
    }
    
    func setEverythingVisible(isVisible: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewToHideAndShow.forEach { $0.isHidden = !isVisible }
        }
    }
    
    func openMainScreen() {
        ARSLineProgress.showSuccess()
        let mainTabBar = self.storyboard!.instantiateViewController(withIdentifier: "MainTabBarController")        
        self.navigationController?.setViewControllers([mainTabBar], animated: true)
        ARSLineProgress.hide()
    }
}
