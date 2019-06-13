//
//  ProfilesListViewModel.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 30.05.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import Foundation

class ProfilesListViewModel {
    
    var artists = [Artist]()
    
    func myUserIfExists(id: String) -> Artist? {
        return artists.filter({ $0.facebookId == id }).first
    }
    
    func loadArtists(completion:(() -> ())) {
        
        NetworkManager.loadArtists(completion: { artists, error in
            if error == nil {
                self.artists = artists.sorted(by: {
                    if GlobalManager.sorting == .lowToHigh {
                        return $0.price < $1.price
                    } else {
                        return $0.price > $1.price
                    }
                })
                self.filteredArtists = self.artists
                
                let idUser = FBSDKAccessToken.current()?.userID ?? ""
                let myUser = self.myUserIfExists(id: idUser)
                GlobalManager.myUser = myUser
            } else {
                //TODO: Show error to user
            }
        })
    }
}
