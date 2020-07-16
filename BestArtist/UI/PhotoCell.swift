//
//  PhotoCell.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 09.07.20.
//  Copyright © 2020 kievkao. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.photoImageView.layer.cornerRadius = 10
        self.photoImageView.clipsToBounds = true
    }

}
