//
//  InstructionsViewController.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 19.08.21.
//  Copyright © 2021 kievkao. All rights reserved.
//

import UIKit
import AVKit

class InstructionsViewController: UIViewController {
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var skipButton: UIButton!
    
    var skipBlock: (() -> Void)?
    var userType: UserType!
    var moviePlayer: AVPlayerViewController?
    var playerLayer: AVPlayerLayer!
    var openFromMenu: Bool = false
    @IBOutlet weak var videoToBottom: NSLayoutConstraint!
    @IBOutlet weak var videoToSkipButton: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if openFromMenu {
            skipButton.isHidden = true
            self.navigationItem.title = "Wie funktioniert's"
            videoToBottom.isActive = true
            videoToSkipButton.isActive = false
        } else {
            videoToBottom.isActive = false
            videoToSkipButton.isActive = true
        }
        
        playVideo()
    }
    
    func playVideo() {
        let fileName = userType == .artist ? "artist_instruction" : "customer_instruction"
        let pathToFile = Bundle.main.path(forResource: fileName, ofType: "mov")!
        let videoURL = URL(fileURLWithPath: pathToFile)
        
        let player = AVPlayer(url: videoURL)
        playerLayer = AVPlayerLayer(player: player)
        videoView.layer.addSublayer(playerLayer)
        player.play()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = videoView.bounds
    }
    
    @IBAction func skipButtonClicked() {
        self.dismiss(animated: true, completion: nil)
        skipBlock?()
    }
}
