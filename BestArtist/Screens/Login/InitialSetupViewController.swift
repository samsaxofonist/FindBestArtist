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

    func openCitySelection(fbProfile: FBSDKProfile) {
        let cityControllerNav = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(identifier: "citySelectionNavigation") as! UINavigationController
        let cityController = cityControllerNav.viewControllers.first as! SelectCityViewController
        setupCityController(cityController, fbProfile: fbProfile)
        self.present(cityControllerNav, animated: true, completion: nil)
    }

    func setupCityController(_ controller: SelectCityViewController, fbProfile: FBSDKProfile) {
        controller.finishBlock = { city, country in
            self.finishLogin(fbProfile: fbProfile, existedArtist: nil, city: city, country: country)
        }
    }

    func finishLogin(fbProfile: FBSDKProfile, existedArtist: User?, city: City, country: String) {
        switch self.userType {
        case .artist:
            GlobalManager.myUser = Artist.instantiate(fromUser: User(facebookId: fbProfile.userID, name: fbProfile.name, country: country, city: city))

            if existedArtist != nil {
                self.openMainScreen()
            } else {
                self.openCreateProfile(fbProfile: fbProfile)
            }
        case .customer:
            let customer = User(facebookId: fbProfile.userID, name: fbProfile.name, country: country, city: city)
            GlobalManager.myUser = customer
            ARSLineProgress.show()
            NetworkManager.saveCustomer(customer) {
                ARSLineProgress.hide()
                self.openMainScreen()
            }
        case .none:
            break
        }
    }

    func openCreateProfile(fbProfile: FBSDKProfile) {
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


}
