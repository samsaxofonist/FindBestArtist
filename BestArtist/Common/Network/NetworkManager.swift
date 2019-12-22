//
//  NetworkManager.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 18.05.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import Foundation

final class NetworkManager {
    
    static func saveArtist(_ artist: User, finish: @escaping (()->())) {
        FirebaseManager.saveArtist(artist, finish: finish)
    }
    
    static func loadArtists(completion: @escaping (([User], Error?) -> Void)) {
        FirebaseManager.loadArtists(completion: completion)
    }
}
