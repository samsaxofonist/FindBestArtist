//
//  MenuViewController.swift
//  FindBestArtist
//
//  Created by Andrii Kravchenko on 04.11.18.
//  Copyright © 2018 Samus Dimitrij. All rights reserved.
//

import UIKit
import SideMenu
import FBSDKLoginKit
import Kingfisher

class MenuViewController: UITableViewController {
    @IBOutlet weak var profileCellTitle: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoView.layer.cornerRadius = 28
        backgroundView.layer.cornerRadius = 30
        SideMenuManager.defaultManager.menuFadeStatusBar = false
        if let artist = GlobalManager.myUser {
            nameLabel.text = artist.name
            if let photoLinkString = artist.photoLink, let photoURL = URL(string: photoLinkString) {
                photoView.kf.setImage(with: ImageResource(downloadURL: photoURL))
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileCellTitle.text = GlobalManager.myUser != nil ? "Edit Profile" : "Create Profile"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let neededNavigation = GlobalManager.navigation
        let rootNavigation = GlobalManager.rootNavigation
        
        if indexPath.row == 1 {
            let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
            let profileController = profileStoryboard.instantiateViewController(withIdentifier: "Profile") as! SetProfilePhotoViewController
            
            if let myUser = GlobalManager.myUser {
                profileController.artist = myUser
            } else {
                profileController.artist = Artist()
            }
            
            neededNavigation?.pushViewController(profileController, animated: true)
            dismiss(animated: true, completion: nil)
        }
        if indexPath.row == 2 {
            FBSDKLoginManager().logOut()
            let newLoginView = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
            
            dismiss(animated: false) {
                rootNavigation?.setViewControllers([newLoginView], animated: true)
            }
        }
    }
    
}
