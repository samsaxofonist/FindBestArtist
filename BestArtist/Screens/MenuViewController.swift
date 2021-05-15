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
    @IBOutlet weak var myOrdersCellTitleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
        self.setupUserInfoInMenu()
    }

    func setup() {
        applyTheme(theme: ThemeManager.theme)
        photoView.layer.cornerRadius = 28
        backgroundView.layer.cornerRadius = 30
        self.tableView.tableFooterView = UIView(frame: .zero)
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

                DispatchQueue.main.async {
                    self.photoView.image = image
                }
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
        self.myOrdersCellTitleLabel.textColor = theme.textColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileCellTitle.text = GlobalManager.myUser != nil ? "Edit Profile" : "Create Profile"
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let neededNavigation = GlobalManager.navigation
        let rootNavigation = GlobalManager.rootNavigation
        
        if indexPath.row == 1, let myUser = GlobalManager.myUser {
            let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
            let profileController = profileStoryboard.instantiateViewController(withIdentifier: "NewProfile") as! MyProfileViewController
            
            if let artist = myUser as? Artist {
                profileController.artist = artist
            } else {
                profileController.artist = Artist.instantiate(fromUser: myUser)
            }

            neededNavigation?.pushViewController(profileController, animated: true)
            dismiss(animated: true, completion: nil)
        } else if indexPath.row == 2 {
            let myOrders = UIStoryboard(name: "MyOrders", bundle: nil).instantiateViewController(withIdentifier: "MyOrdersViewController")

            neededNavigation?.pushViewController(myOrders, animated: true)
            dismiss(animated: true, completion: nil)
        }
        else if indexPath.row == 3 {
            LoginManager().logOut()
            let newLoginView = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
            
            dismiss(animated: false) {
                rootNavigation?.setViewControllers([newLoginView], animated: true)
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NeedHideTabBar"), object: nil)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 && GlobalManager.myUser?.type == .customer {
            return 0
        } else {
            return UITableView.automaticDimension
        }
    }
    
}
