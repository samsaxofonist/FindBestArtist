//
//  FirstLaunchDetector.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 19.08.21.
//  Copyright © 2021 kievkao. All rights reserved.
//

import Foundation

class FirstLaunchDetector {
    static let customerKey = "appWasLaunched_customer"
    static let artistKey = "appWasLaunched_artist"
    
    static func isFirstLaunch(for userType: UserType) -> Bool {
        let key = userType == .artist ? artistKey : customerKey
        return !UserDefaults.standard.bool(forKey: key)
    }
    
    static func markAsLaunched(for userType: UserType) {
        let key = userType == .artist ? artistKey : customerKey
        UserDefaults.standard.setValue(true, forKey: key)
    }
}
