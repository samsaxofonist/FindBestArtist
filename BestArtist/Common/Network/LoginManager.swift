//
//  LoginManager.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 05.03.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import Foundation
import Firebase
import FBSDKLoginKit

class LoginManager {
    static var isLoggedIn: Bool {
        return FBSDKAccessToken.current() != nil && Auth.auth().currentUser != nil
    }
    
    static func login(fromViewController viewController: UIViewController, progressStartBlock: @escaping (()->()), completion: @escaping ((Bool) -> ())) {
        loginToFacebook(fromViewController: viewController, completion: { isFacebookOK in
            guard isFacebookOK, let token = FBSDKAccessToken.current() else {
                completion(false)
                return
            }
            progressStartBlock()            
            self.loginToFirebase(token: token.tokenString, completion: { isFirebaseOK in
                completion(isFirebaseOK)
            })
        })
    }
    
    static private func loginToFirebase(token: String, completion: @escaping ((Bool) -> ())) {
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        Auth.auth().signInAndRetrieveData(with: credential, completion: { (result, error) in
            completion(error == nil)
        })
    }
    
    static private func loginToFacebook(fromViewController viewController: UIViewController, completion: @escaping ((Bool) -> ())) {
        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile", "email"], from: viewController) { (result, error) in
            completion(error == nil)
        }
    }
}
