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
    
    var ref: DatabaseReference = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilesTableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        NavigationHolder.navigation = self.navigationController!
        
        //testLoadData()
    }
    
    func testLoadData() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() { return }
            
            let username = snapshot.childSnapshot(forPath: "name").value
            print(username!)
        }) { (error) in
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
