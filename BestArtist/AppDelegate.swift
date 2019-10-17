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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        FBSDKSettings.setAutoLogAppEventsEnabled(NSNumber(booleanLiteral: false))
        FBSDKApplicationDelegate.sharedInstance()?.application(application, didFinishLaunchingWithOptions: launchOptions)
        let attrs = [
            NSAttributedString.Key.foregroundColor: ThemeManager.theme.textColor,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24)
        ]
        
        UINavigationBar.appearance().titleTextAttributes = attrs
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance()!.application(app, open: url, options: options)
        return handled
    }
    
}

