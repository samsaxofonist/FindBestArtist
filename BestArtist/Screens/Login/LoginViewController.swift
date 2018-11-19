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


class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
                
        if FBSDKAccessToken.current() != nil {
            openMainScreen()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        
        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            guard error == nil, let token = FBSDKAccessToken.current() else { return }
            let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
            Auth.auth().signInAndRetrieveData(with: credential, completion: { (result, error) in
                self.openMainScreen()
            })
        }
    }
    
    func openMainScreen() {
        let mainTabBar = self.storyboard!.instantiateViewController(withIdentifier: "MainTabBarController")        
        self.navigationController?.setViewControllers([mainTabBar], animated: true)
    }
}
