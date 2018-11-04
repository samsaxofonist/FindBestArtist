//
//  AppDelegate.swift
//  FindBestArtist
//
//  Created by Andrii Kravchenko on 11.10.18.
//  Copyright © 2018 Samus Dimitrij. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        FBSDKApplicationDelegate.sharedInstance()?.application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance()!.application(app, open: url, options: options)
        return handled
    }
}

