//
//  NetworkManager.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 18.05.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import Foundation

final class NetworkManager {
    
    static func saveArtist(_ artist: Artist, finish: @escaping (()->())) {
        FirebaseManager.saveArtist(artist, finish: finish)
    }
    
    static func loadArtists(completion: @escaping (([Artist], Error?) -> Void)) {
        FirebaseManager.loadArtists(completion: completion)
    }
}
