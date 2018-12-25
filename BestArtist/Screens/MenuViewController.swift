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

class MenuViewController: UITableViewController {
    @IBOutlet weak var profileCellTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let neededNavigation = NavigationHolder.navigation
        let rootNavigation = NavigationHolder.rootNavigation
        
        if indexPath.row == 0 {
            let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
            let profileController = profileStoryboard.instantiateViewController(withIdentifier: "Profile")
            neededNavigation?.pushViewController(profileController, animated: true)
            dismiss(animated: true, completion: nil)
        }
        if indexPath.row == 1 {
            FBSDKLoginManager().logOut()
            let newLoginView = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
            
            dismiss(animated: false) {
                rootNavigation?.setViewControllers([newLoginView], animated: true)
            }
        }
    }
    
}
