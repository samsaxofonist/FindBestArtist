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
    @IBOutlet weak var getButton: UIButton!
    @IBOutlet weak var smallBackgroundView: UIView!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.needGradient = true
        smallBackgroundView.layer.cornerRadius = 10
        getButton.layer.cornerRadius = 25
        //blurEffect()
        tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")

        greetingLabel.text = "Hi, \(GlobalManager.myUser?.name ?? "user")"
        updateTotalPrice()
    }
    
    @IBAction func GetButtonClicked(_ sender: Any) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalManager.selectedArtists.count
    }
    
    //func blurEffect() {
       // let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
       // let blurEffectView = UIVisualEffectView(effect: blurEffect)
       // blurEffectView.frame = view.bounds
       // blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
       // smallBackgroundView.addSubview(blurEffectView)
    //}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        cell.checkBox.isHidden = true
        let artist = GlobalManager.selectedArtists[indexPath.row]
        cell.setupWithArtist(artist)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)

        let detailsVC = profileStoryboard.instantiateViewController(withIdentifier: "NewProfile") as! MyProfileViewController
        let artist = GlobalManager.selectedArtists[indexPath.row]
        detailsVC.artist = artist
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            GlobalManager.selectedArtists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            updateTotalPrice()
        }
    }

    func updateTotalPrice() {
        let totalPrice = GlobalManager.selectedArtists.reduce(0) { $0 + $1.price }
        totalPriceLabel.text = "Total: \(totalPrice) €"
    }
}
