//
//  ProfileCell.swift
//  FindBestArtist
//
//  Created by Andrii Kravchenko on 20.10.18.
//  Copyright © 2018 Samus Dimitrij. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var mainBackgroundProfileCell: UIView!
    @IBOutlet weak var viewForGradient: UIView!
    
    var gradient = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoImage.layer.cornerRadius = 60
        drawGradient()
    }
    
    func drawGradient() {
        gradient.frame = self.viewForGradient.bounds
        gradient.colors = [UIColor(red: 198/255, green: 244/255, blue: 249/255, alpha: 1.0).cgColor, UIColor(red: 26/255, green: 126/255, blue: 192/255, alpha: 1.0).cgColor]
        viewForGradient.layer.addSublayer(gradient)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = self.viewForGradient.bounds
    }
}
