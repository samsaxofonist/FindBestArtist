//
//  InitialSetupViewController.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 24.06.20.
//  Copyright © 2020 kievkao. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import ARSLineProgress

class InitialSetupViewController: BaseViewController {

    var userType: UserType!


    func finishLogin(fbProfile: Profile, existedArtist: User, city: City, country: String) {
        GlobalManager.myUser = existedArtist
        self.openMainScreen()
    }
    
    func processNewUser(fbProfile: Profile, city: City, country: String, dates: [TimeInterval]) {
        switch self.userType {
        case .artist:
            processArtistFlow(fbProfile: fbProfile, city: city, country: country, dates: dates)
        case .customer:
            processCustomerFlow(fbProfile: fbProfile, city: city, country: country, dates: dates)
        case .none:
            break
        }
    }
    
    func processArtistFlow(fbProfile: Profile, city: City, country: String, dates: [TimeInterval]) {
        let newArtist = Artist.instantiate(fromUser: User(facebookId: fbProfile.userID, name: fbProfile.name ?? "", country: country, city: city))
        newArtist.dates = dates
        
        GlobalManager.myUser = newArtist
        
        self.openCreateProfile(fbProfile: fbProfile)
    }
    
    func processCustomerFlow(fbProfile: Profile, city: City, country: String, dates: [TimeInterval]) {
        let customer = User(facebookId: fbProfile.userID, name: fbProfile.name ?? "", country: country, city: city)
        customer.dates = dates
        
        GlobalManager.myUser = customer
        
        ARSLineProgress.show()
        NetworkManager.saveCustomer(customer) {
            ARSLineProgress.hide()
            self.openMainScreen()
        }
    }

    func openCreateProfile(fbProfile: Profile) {
        guard let user = GlobalManager.myUser else { return }
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileVC = profileStoryboard.instantiateViewController(withIdentifier: "NewProfile") as! MyProfileViewController
        profileVC.artist = Artist.instantiate(fromUser: user)
        profileVC.isNewProfile = true
        self.navigationController?.setViewControllers([profileVC], animated: false)
    }

    func openMainScreen() {
        let mainContainer = self.storyboard!.instantiateViewController(withIdentifier: "rootContainer")
        self.navigationController?.setViewControllers([mainContainer], animated: true)
    }

    func openEventDateScreen(fbProfile: Profile) {
        let cityDateSelectVC = UIStoryboard(name: "Helpers", bundle: nil).instantiateViewController(withIdentifier: "cityDateSelectVC") as! EventDateSelectionViewController
        cityDateSelectVC.userType = userType
        
        cityDateSelectVC.finishBlock = { [weak self] selectedDates, city, country in
            self?.processNewUser(fbProfile: fbProfile, city: city, country: country, dates: selectedDates)
        }
        
        self.navigationController?.pushViewController(cityDateSelectVC, animated: true)
    }
}
