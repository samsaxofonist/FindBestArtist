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
        
        login(completion: { isOK in
            if isOK {
                self.openMainScreen()
            } else {
                self.setEverythingVisible(isVisible: true)
            }
        })
    }
    
    func login(completion: @escaping ((Bool) -> ())) {
        loginToFacebook(completion: { isFacebookOK in
            guard isFacebookOK, let token = FBSDKAccessToken.current() else {
                completion(false)
                return
            }
            
            ARSLineProgress.show()
            self.loginToFirebase(token: token.tokenString, completion: { isFirebaseOK in
                completion(isFirebaseOK)
            })
        })
    }
    
    func loginToFirebase(token: String, completion: @escaping ((Bool) -> ())) {
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        Auth.auth().signInAndRetrieveData(with: credential, completion: { (result, error) in
            completion(error == nil)
        })
    }
    
    func loginToFacebook(completion: @escaping ((Bool) -> ())) {
        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            completion(error == nil)
        }
    }
    
    func setEverythingVisible(isVisible: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            ARSLineProgress.hide()
            self.viewToHideAndShow.forEach { $0.isHidden = !isVisible }
        }
    }
    
    func openMainScreen() {
        let mainTabBar = self.storyboard!.instantiateViewController(withIdentifier: "MainTabBarController")        
        self.navigationController?.setViewControllers([mainTabBar], animated: true)
        ARSLineProgress.hide()
    }
}
