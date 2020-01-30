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
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!

    var onClickBlock: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyTheme(theme: ThemeManager.theme)
        photoImage.layer.cornerRadius = 60
        backgroundPhotoView.layer.cornerRadius = 61        
    }
    
    func applyTheme(theme: Theme) {
        nameLabel.textColor = theme.darkColor
        priceLabel.textColor = theme.textColor
        informationLabel.textColor = theme.textColor
        fromLabel.textColor = theme.textColor
        currencyLabel.textColor = theme.textColor
    }
    
    @IBAction func selectionAction(_ sender: Any) {
        onClickBlock?()
    }
    
    func setupWithArtist(_ artist: Artist) {
        nameLabel.text = artist.name
        priceLabel.text = String(artist.price)
        informationLabel.text = artist.talent.description
        
        if let link = artist.photoLink, let photoURL = URL(string: link) {
            photoImage.kf.setImage(with: ImageResource(downloadURL: photoURL))
        }
    }
}
