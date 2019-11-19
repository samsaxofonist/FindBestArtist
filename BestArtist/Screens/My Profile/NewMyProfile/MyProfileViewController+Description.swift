//
//  MyProfileViewController+Description.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 24.07.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit
import Kingfisher

extension MyProfileViewController {
    
    func showInitialArtistInfo() {
        if artist.description.isEmpty == false {
            descriptionTextView.text = artist.description
        }
        nameTextField.text = artist.name
        self.selectedCity = artist.city
        self.selectedCountry = artist.country
        cityButton.setTitle(artist.city.name, for: .normal)
        priceButton.setTitle(String(artist.price), for: .normal)
        if let index = talents.index(of: artist.talent) {
            selectedRole = talents[index]
        }
        loadAllPhotos()
        loadAllVideos()
    }

    func loadAllVideos() {
        artist.youtubeLinks.forEach { link in
            let videoId: String?

            if link.contains("="), let lastAfterEqual = link.components(separatedBy: "=").last {
                videoId = lastAfterEqual
            } else if let lastAfterSlash = link.components(separatedBy: "/").last {
                videoId = lastAfterSlash
            } else {
                videoId = nil
            }

            if let id = videoId {
                self.insertNewVideo(videoId: id)
            }
        }
    }

    func loadAllPhotos() {
        artist.galleryPhotosLinks.forEach {
            let url = URL(string: $0)

            KingfisherManager.shared.retrieveImage(with: ImageResource(downloadURL: url!), options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    self.insertNewPhoto(value.image)
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        textView.scrollRangeToVisible(NSMakeRange(textView.text.count-1, 0))
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        tableView.scrollToRow(at: IndexPath(item: 1, section: 0), at: .bottom, animated: false)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == defaultDescriptionText {
            textView.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == nil || textView.text.isEmpty {
            textView.text = defaultDescriptionText
        }
    }
    
    func descriptionCellHeight() -> CGFloat {
        let text = descriptionTextView.text ?? ""
        let font = descriptionTextView.font!
        let width = UIScreen.main.bounds.width - 32
        
        let rect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let neededArea = text.boundingRect(with: rect,
                                           options: .usesLineFragmentOrigin,
                                           attributes: [.font: font], context: nil)
        
        return neededArea.height + 18
    }
}
