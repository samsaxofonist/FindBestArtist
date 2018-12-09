//
//  ProfilesListViewController.swift
//  FindBestArtist
//
//  Created by Andrii Kravchenko on 20.10.18.
//  Copyright © 2018 Samus Dimitrij. All rights reserved.
//

import UIKit
import SideMenu
import Firebase
import FirebaseDatabase

class ProfilesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var profilesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilesTableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        NavigationHolder.navigation = self.navigationController!
        
        //testLoadData()
    }
    
    func testLoadData() {
        
        let ref = Database.database().reference().child("users")
        ref.childByAutoId().setValue(["name": "Ivan", "price": 1000, "description": "Super good"])
        ref.childByAutoId().setValue(["name": "Bill", "price": 200, "description": "Bad"])
        
        ref.observeSingleEvent(of: .value, with: { data in
            guard let jsonData = data.value as? [String: [String: Any]] else { return }
            for (key, value) in jsonData {
                print("******* User with ID: \(key) **********")
                print(value["name"] as! String)
                print(value["description"] as! String)
                print(value["price"] as! Int)
                print("*****************")
            }
        }) { error in
            print(error.localizedDescription)
        }

    }
    
    @objc func menuButtonClicked() {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
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
