//
//  ProfileCell.swift
//  FindBestArtist
//
//  Created by Andrii Kravchenko on 20.10.18.
//  Copyright © 2018 Samus Dimitrij. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileCell: UITableViewCell {
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var mainBackgroundProfileCell: UIView!
    @IBOutlet weak var backgroundPhotoView: UIView!
    
    var onClickBlock: (() -> ())!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoImage.layer.cornerRadius = 60
        backgroundPhotoView.layer.cornerRadius = 61        
    }
    
    @IBAction func selectionAction(_ sender: Any) {
        onClickBlock()
    }
    
    func setupWithArtist(_ artist: Artist) {
        nameLabel.text = artist.name
        priceLabel.text = String(artist.price)
        informationLabel.text = artist.talent
        
        if let photoLinkString = artist.photoLink, let photoURL = URL(string: photoLinkString) {
            photoImage.kf.setImage(with: ImageResource(downloadURL: photoURL))
        }
    }
}
