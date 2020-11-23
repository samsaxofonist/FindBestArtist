//
//  ArtistLoader.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 21.10.20.
//  Copyright © 2020 kievkao. All rights reserved.
//

import Foundation

class ArtistLoader {

    func loadArtists(infos: [ArtistOrderInfo], completion: @escaping (([Artist]) -> Void)) {
        var artists = [Artist]()
        var loadedArtistsCounter = 0

        for artistInfo in infos {
            FirebaseManager.loadArtist(byFacebookId: artistInfo.artistId, completion: { artist in
                loadedArtistsCounter += 1
                if let loadedArtist = artist {
                    artists.append(loadedArtist)
                }
                if loadedArtistsCounter == infos.count {
                    completion(artists)
                }
            })
        }
    }
}
