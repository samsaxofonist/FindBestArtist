//
//  ProfilesListViewController.swift
//  FindBestArtist
//
//  Created by Andrii Kravchenko on 20.10.18.
//  Copyright © 2018 Samus Dimitrij. All rights reserved.
//

import UIKit

class ProfilesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var profilesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilesTableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetailsSegue", sender: nil)
    }
}
