//
//  OrderDetailsViewController.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 15.10.20.
//  Copyright © 2020 kievkao. All rights reserved.
//

import UIKit

class OrderDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var order: Order!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    let artistsLoader = ArtistLoader()
    var loadedArtists = [Artist]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView(frame: .zero)
        self.navigationItem.title = "Order details"
        artistsLoader.loadArtists(infos: order.artists) { artists in
            self.loadedArtists = artists
            self.tableView.reloadData()
        }

        priceLabel.text = String(order.artists.reduce(0) { $0 + $1.fixedPrice }) + "€"
        dateLabel.text = MyOrderCell.dateFormatter.string(from: order.date)
        tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadedArtists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        cell.checkBox.isHidden = true
        let artist = loadedArtists[indexPath.row]
        cell.setupWithArtist(artist)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)

        let detailsVC = profileStoryboard.instantiateViewController(withIdentifier: "NewProfile") as! MyProfileViewController
        let artist = loadedArtists[indexPath.row]
        detailsVC.artist = artist
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
