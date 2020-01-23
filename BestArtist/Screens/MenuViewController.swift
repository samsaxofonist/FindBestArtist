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
    @IBOutlet weak var profileCellTitleLabel: UILabel!
    @IBOutlet weak var logoutCellTitleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyTheme(theme: ThemeManager.theme)
        photoView.layer.cornerRadius = 28
        backgroundView.layer.cornerRadius = 30
        self.tableView.tableFooterView = UIView(frame: .zero)
        setupUserInfoInMenu()
    }

    func setupUserInfoInMenu() {
        if let user = GlobalManager.myUser {
            nameLabel.text = user.name
            loadUserPhoto(user: user)
        }
    }

    func loadUserPhoto(user: User) {
        if let photo = user.photo {
            photoView.image = photo
        } else if let link = user.photoLink, let photoURL = URL(string: link) {
            GlobalManager.myUser?.photoLink = link
            photoView.kf.setImage(with: ImageResource(downloadURL: photoURL))
        } else {
            loadFacebookPhoto { image, url in
                GlobalManager.myUser?.photoLink = url?.absoluteString
                GlobalManager.myUser?.photo = image
                self.photoView.image = image
            }
        }
    }

    func loadFacebookPhoto(block: @escaping ((UIImage?, URL?) -> Void)) {
        NetworkManager.loadFacebookPhoto(block: block)
    }

    func applyTheme(theme: Theme) {
        self.view.backgroundColor = theme.backgroundColor
        self.nameLabel.textColor = theme.textColor
        self.profileCellTitleLabel.textColor = theme.textColor
        self.logoutCellTitleLabel.textColor = theme.textColor
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
            let profileController = profileStoryboard.instantiateViewController(withIdentifier: "NewProfile") as! MyProfileViewController
            
            if let myUser = GlobalManager.myUser as? Artist {
                profileController.artist = myUser
            }
            
            neededNavigation?.pushViewController(profileController, animated: true)
            dismiss(animated: true, completion: nil)
        } else if indexPath.row == 2 {
            FBSDKLoginManager().logOut()
            let newLoginView = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
            
            dismiss(animated: false) {
                rootNavigation?.setViewControllers([newLoginView], animated: true)
            }
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 && GlobalManager.myUser?.type == .customer {
            return 0
        } else {
            return UITableView.automaticDimension
        }
    }
    
}
