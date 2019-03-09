//
//  CartVC.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 09.03.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit

class CartVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.needGradient = false
        tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalManager.selectedArtists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        let artist = GlobalManager.selectedArtists[indexPath.row]
        cell.setupWithArtist(artist)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = self.storyboard?.instantiateViewController(withIdentifier: "detailsContainer") as! ArtistDetailsContainerController
        let artist = GlobalManager.selectedArtists[indexPath.row]
        detailsVC.selectedArtist = artist
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
}