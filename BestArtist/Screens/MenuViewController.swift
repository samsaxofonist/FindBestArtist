//
//  MenuViewController.swift
//  FindBestArtist
//
//  Created by Andrii Kravchenko on 04.11.18.
//  Copyright © 2018 Samus Dimitrij. All rights reserved.
//

import UIKit
import SideMenu

class MenuViewController: UITableViewController {
    @IBOutlet weak var profileCellTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let neededNavigation = NavigationHolder.navigation
        let profileController = self.storyboard!.instantiateViewController(withIdentifier: "Profile")
        neededNavigation?.pushViewController(profileController, animated: true)
        dismiss(animated: true, completion: nil)
    }
}
