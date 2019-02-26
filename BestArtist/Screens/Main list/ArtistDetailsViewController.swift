//
//  ArtistDetailsViewController.swift
//  BestArtist
//
//  Created by Dima on 12.02.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit
import Kingfisher
import ImageSlideshow

class ArtistDetailsViewController: UITableViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIView!
    @IBOutlet weak var artistPhotoImageView: UIImageView!
    var selectedArtist: Artist!
    
    @IBOutlet weak var infoArtistLabel: UILabel!
    @IBOutlet weak var slideShow: ImageSlideshow!
    let images = [UIImage(named: "p1"), UIImage(named: "p2"), UIImage(named: "p3"), UIImage(named: "p4"), UIImage(named: "p5")]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        
        if let photoLinkString = selectedArtist.photoLink, let photoURL = URL(string: photoLinkString) {
            artistPhotoImageView.kf.setImage(with: ImageResource(downloadURL: photoURL))
            artistPhotoImageView.layer.cornerRadius = 100
            backgroundImageView.layer.cornerRadius = 102
            infoArtistLabel.text = selectedArtist.description
            }
        
        func setupWithArtist(_ artist: Artist) {
            nameLabel.text = artist.name
            //priceLabel.text = String(artist.price)
            infoArtistLabel.text = artist.description
        }
        
        let sources = [ImageSource(image: images[0]!), ImageSource(image: images[1]!), ImageSource(image: images[2]!), ImageSource(image: images[3]!), ImageSource(image: images[4]!)]
        slideShow.setImageInputs(sources)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ArtistDetailsViewController.didTap))
        slideShow.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func didTap() {
        slideShow.presentFullScreenController(from: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
