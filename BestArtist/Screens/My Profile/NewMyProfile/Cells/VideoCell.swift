//
//  VideoCell.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 22.08.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class VideoCell: UICollectionViewCell {
    @IBOutlet weak var playerView: YTPlayerView!
    
    var deleteHandler: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.playerView.layer.cornerRadius = 10
        self.playerView.clipsToBounds = true
    }
    
    @IBAction func deleteButtonClicked() {
        deleteHandler?()
    }
}
