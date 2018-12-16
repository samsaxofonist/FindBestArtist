//
//  GetVideoViewController.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 16.12.18.
//  Copyright © 2018 kievkao. All rights reserved.
//

import UIKit
import AVKit
import youtube_ios_player_helper

class GetVideoViewController: WithoutTabbarViewController {

    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var videoView: YTPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loadVideoClicked(_ sender: Any) {
        self.view.endEditing(true)
        guard let textValue = textfield.text, !textValue.isEmpty else {return}
        if isYoutubeURL(string: textValue) {
            processYoutube(string: textValue)
        } else if isVideoUrl(string: textValue) {
            processOther(string: textValue)
        } else {
            // показать ошибку
        }
    }
    
    func isYoutubeURL(string: String) -> Bool {
        return string.range(of: "(http(s)?:\\/\\/)?(www\\.|m\\.)?youtu(be\\.com|\\.be)(\\/watch\\?([&=a-z]{0,})(v=[\\d\\w]{1,}).+|\\/[\\d\\w]{1,})", options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    func processYoutube(string: String) {
        let idText = (string as NSString).lastPathComponent
        self.videoView.load(withVideoId: idText)
    }
    
    func processOther(string: String) {
        guard let url = URL(string: string) else { return }
        DispatchQueue.global().async {
            guard let videoDataFromUrl = try? Data(contentsOf: url), let urlToFile = self.saveFileToDisk(data: videoDataFromUrl) else { return }
            self.playVideoFromURL(url: urlToFile)
        }
    }
    
    func playVideoFromURL(url: URL) {
        let player = AVPlayer(url: url)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
    
    func saveFileToDisk(data: Data) -> URL? {
        let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
        let fileURL = documentDirectory.appendingPathComponent("video.mp4")
        do {
            try data.write(to: fileURL)
            return fileURL
        } catch {
            return nil
        }
    }
    
    func isVideoUrl(string: String) -> Bool {
        let imageFormats = ["mp4", "mov", "avi"]
        
        if URL(string: string) != nil  {
            let extensi = (string as NSString).pathExtension
            return imageFormats.contains(extensi)
        }
        return false
    }
}
