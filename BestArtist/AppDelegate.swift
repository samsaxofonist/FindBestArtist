//
//  AppDelegate.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 19.11.18.
//  Copyright © 2018 kievkao. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import ARSLineProgress

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        FBSDKSettings.setAutoLogAppEventsEnabled(NSNumber(booleanLiteral: false))
        FBSDKApplicationDelegate.sharedInstance()?.application(application, didFinishLaunchingWithOptions: launchOptions)
        let attrs = [
            NSAttributedString.Key.foregroundColor: ThemeManager.theme.textColor,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)
        ]
        ARSLineProgressConfiguration.backgroundViewStyle = .full
        UINavigationBar.appearance().titleTextAttributes = attrs
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance()!.application(app, open: url, options: options)
        return handled
    }
    
}

