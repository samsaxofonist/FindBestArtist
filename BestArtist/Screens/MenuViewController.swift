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
    @IBOutlet weak var settingsCellTitleLabel: UILabel!
    @IBOutlet weak var helpCellTitleLabel: UILabel!
    @IBOutlet weak var messagesTitleLabel: UILabel!
    
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
        addVerticalSeparator()
    }
    
    func addVerticalSeparator() {
        let separator = UIView(frame: CGRect(x: 240, y: -20, width: 1, height: self.view.frame.height))
        separator.backgroundColor = .black
        separator.clipsToBounds = false
        separator.layer.shadowOpacity = 1
        separator.layer.shadowOffset = .zero
        separator.layer.shadowRadius = 10
        tableView.addSubview(separator)
    }

    func setupUserInfoInMenu() {
        if let user = GlobalManager.myUser {
            nameLabel.text = "Hi, " + user.name
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
        self.settingsCellTitleLabel.textColor = theme.textColor
        self.helpCellTitleLabel.textColor = theme.textColor
        self.messagesTitleLabel.textColor = theme.textColor
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
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NeedHideTabBar"), object: nil)
        } else if indexPath.row == 2 {
            let myOrders = UIStoryboard(name: "MyOrders", bundle: nil).instantiateViewController(withIdentifier: "MyOrdersViewController")

            neededNavigation?.pushViewController(myOrders, animated: true)
            dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NeedHideTabBar"), object: nil)
        }
        else if indexPath.row == 3 {
            openCityDateSelection()
        } else if indexPath.row == 4 {
            openMessages()
        } else if indexPath.row == 5 {
            let instruction = InstructionsViewController()
            instruction.openFromMenu = true
            neededNavigation?.pushViewController(instruction, animated: true)
            dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NeedHideTabBar"), object: nil)
        } else if indexPath.row == 6 {
            LoginManager().logOut()
            let newLoginView = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
            
            dismiss(animated: false) {
                rootNavigation?.setViewControllers([newLoginView], animated: true)
            }
        }
    }
    
    func openMessages() {
        let messagesVC = UIStoryboard(name: "Messages", bundle: nil).instantiateInitialViewController() as! AdminContactedUsersListViewController
        GlobalManager.navigation?.pushViewController(messagesVC, animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func openCityDateSelection() {
        let cityDateSelectVC = UIStoryboard(name: "Helpers", bundle: nil).instantiateViewController(withIdentifier: "cityDateSelectVC") as! EventDateSelectionViewController
        cityDateSelectVC.source = .settings
        cityDateSelectVC.userType = GlobalManager.myUser!.type
        
        cityDateSelectVC.finishBlock = { selectedDates, city, country in
            GlobalManager.myUser?.dates = selectedDates
            GlobalManager.myUser?.city = city
            GlobalManager.myUser?.country = country
        }
        GlobalManager.navigation?.pushViewController(cityDateSelectVC, animated: true)
        dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NeedHideTabBar"), object: nil)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 && GlobalManager.myUser?.type == .customer {
            return 0
        } else if indexPath.row == 3 && GlobalManager.myUser?.type == .artist {
            return 0
        }
        else {
            return UITableView.automaticDimension
        }
    }
    
}
