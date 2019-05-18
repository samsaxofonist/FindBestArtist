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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.needGradient = true
        smallBackgroundView.layer.cornerRadius = 10
        getButton.layer.cornerRadius = 25
        //blurEffect()
        tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
    }
    
    @IBAction func delButtonClicked(_ sender: Any) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
        } else {
           tableView.setEditing(true, animated: true)
        }
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            GlobalManager.selectedArtists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
