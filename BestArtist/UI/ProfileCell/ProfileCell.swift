//
//  ProfileCell.swift
//  FindBestArtist
//
//  Created by Andrii Kravchenko on 20.10.18.
//  Copyright © 2018 Samus Dimitrij. All rights reserved.
//

import UIKit
import Kingfisher
import M13Checkbox
import Cosmos

class ProfileCell: UITableViewCell {
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var mainBackgroundProfileCell: UIView!
    @IBOutlet weak var ratingCount: UILabel!
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var checkBox: M13Checkbox!
    var onClickBlock: (() -> ())?
    
    var isTop: Bool = false
    var isDisplayedInCart: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyTheme(theme: ThemeManager.theme)
        photoImage.layer.cornerRadius = 40
        priceLabel.layer.cornerRadius = 11
        ratingView.isUserInteractionEnabled = false
        ratingView.settings.fillMode = .precise
    }
    
    func applyTheme(theme: Theme) {
        nameLabel.textColor = theme.darkColor
        priceLabel.textColor = theme.artistCellTextColor
        informationLabel.textColor = theme.textColor
    }
    
    @IBAction func selectionAction(_ sender: Any) {
        onClickBlock?()
    }
    
    func setupWithArtist(_ artist: Artist) {
        nameLabel.text = artist.name
        priceLabel.text = "€ " + String(artist.price)
        informationLabel.text = artist.city.name
        checkBox.checkState = GlobalManager.selectedArtists.contains { $0.facebookId == artist.facebookId } ? .checked : .unchecked
        
        ratingView.rating = 1
        ratingCount.text = String(artist.rating)
        
        if GlobalManager.myUser?.type == .artist {
            checkBox.isHidden = true
        } else {
            checkBox.isHidden = isDisplayedInCart
        }        
        
        if let link = artist.photoLink, let photoURL = URL(string: link) {
            photoImage.kf.setImage(with: ImageResource(downloadURL: photoURL))
        }
        mainBackgroundProfileCell.layer.shadowColor = isTop ? UIColor(rgb: 0xFD6B2E).cgColor : UIColor(rgb: 0xAAAAAA).cgColor
    }
}
