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

final class LoginManager {
    static var hasUser: Bool {
        return FBSDKAccessToken.current() != nil && Auth.auth().currentUser != nil
    }
    
    static func login(fromViewController viewController: UIViewController, progressStartBlock: @escaping (()->()), completion: @escaping ((FBSDKProfile?, User?) -> ())) {
        loginToFacebook(fromViewController: viewController, completion: { isFacebookOK in
            guard isFacebookOK, let token = FBSDKAccessToken.current() else {
                completion(nil, nil)
                return
            }
            progressStartBlock()
            self.loginToFirebase(token: token.tokenString, completion: { profile, existedUser  in
                completion(profile, existedUser)
            })
        })
    }

    static func getFacebookEmail(completion: @escaping ((String?) -> Void)) {
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email"])?.start(completionHandler: { (connection, result, error) in
            if let resultDict = result as? [String: Any], error == nil {
                completion(resultDict["email"] as? String)
            } else {
                completion(nil)
            }
        })
    }

    static func loginWithSavedUser(completion: @escaping ((FBSDKProfile?, User?) -> ())) {
        guard let fbToken = FBSDKAccessToken.current() else {
            return completion(nil, nil)
        }
        loginToFirebase(token: fbToken.tokenString, completion: completion)
    }
    
    static private func loginToFirebase(token: String, completion: @escaping ((FBSDKProfile?, User?) -> ())) {
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        Auth.auth().signIn(with: credential, completion: { (result, error) in
            FBSDKProfile.loadCurrentProfile { (profile, error) in
                guard let profile = profile else {
                    return completion(nil, nil)
                }

                FirebaseManager.loadArtist(byFacebookId: profile.userID) { artist in
                    if artist != nil {
                        completion(profile, artist)
                    } else {
                        FirebaseManager.loadCustomer(byFacebookId: profile.userID) { customer in
                            if customer != nil {
                                completion(profile, customer)
                            } else {
                                completion(profile, nil)
                            }
                        }
                    }
                }
            }
        })
    }
    
    static private func loginToFacebook(fromViewController viewController: UIViewController, completion: @escaping ((Bool) -> ())) {
        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile", "email"], from: viewController) { (result, error) in
            completion(error == nil)
        }
    }
}
