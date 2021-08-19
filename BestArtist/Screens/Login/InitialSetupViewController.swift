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
        self.openFirstScreen()
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
            self.openFirstScreen()
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

    func openFirstScreen() {
        guard let userType = GlobalManager.myUser?.type else { return }
        
        if FirstLaunchDetector.isFirstLaunch(for: userType) {
            openInstructionsScreen()
        } else {
            openMainScreen()
        }
    }
    
    func openMainScreen() {
        let mainContainer = self.storyboard!.instantiateViewController(withIdentifier: "rootContainer")
        self.navigationController?.setViewControllers([mainContainer], animated: true)
    }
    
    func openInstructionsScreen() {
        guard let userType = GlobalManager.myUser?.type else { return }
        
        let instructionController = InstructionsViewController()
        instructionController.userType = userType
        instructionController.modalPresentationStyle = .fullScreen
        instructionController.modalTransitionStyle = .crossDissolve
        
        instructionController.skipBlock = { [weak self] in
            FirstLaunchDetector.markAsLaunched(for: userType)            
            self?.openMainScreen()
        }
        self.present(instructionController, animated: true, completion: nil)
    }

    func openEventDateScreen(fbProfile: Profile) {
        let cityDateSelectVC = UIStoryboard(name: "Helpers", bundle: nil).instantiateViewController(withIdentifier: "cityDateSelectVC") as! EventDateSelectionViewController
        cityDateSelectVC.source = .createProfile
        cityDateSelectVC.userType = userType
        
        cityDateSelectVC.finishBlock = { [weak self] selectedDates, city, country in
            self?.processNewUser(fbProfile: fbProfile, city: city, country: country, dates: selectedDates)
        }
        
        self.navigationController?.pushViewController(cityDateSelectVC, animated: true)
    }
}
