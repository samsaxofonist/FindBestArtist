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
            // показать следующий экран
            return
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @IBAction func loginClicked(_ sender: Any) {
        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            Auth.auth().signInAndRetrieveData(with: credential, completion: { (result, error) in
                print("Hello")
            })
        }
    }
}
