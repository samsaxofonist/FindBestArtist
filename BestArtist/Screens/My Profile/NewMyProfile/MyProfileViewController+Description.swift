//
//  MyProfileViewController+Description.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 24.07.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit
import Kingfisher

enum ProfileScreenState {
    case info
    case media
    case feedback
}

extension MyProfileViewController: UITextViewDelegate {
    
    func showInitialArtistInfo() {
        let canEdit = GlobalManager.myUser == artist
        self.nameTextField.isUserInteractionEnabled = canEdit
        self.artistTypeLabel.isHidden = canEdit
        self.artistTypeMenu.isHidden = !canEdit
        self.cityButton.isUserInteractionEnabled = canEdit
        self.priceButton.isUserInteractionEnabled = canEdit
        self.descriptionTextView.isUserInteractionEnabled = canEdit
        self.calendarView.isUserInteractionEnabled = canEdit

        if !canEdit {
            self.allPhotos.removeAll()
        }

        self.selectedPrice = artist.price
        if let photoLink = artist.photoLink {
            self.userPhotoURL = URL(string: photoLink)
        }
        self.selectedDates = artist.busyDates
        
        if artist.description.isEmpty == false {
            descriptionTextView.text = artist.description
        }
        nameTextField.text = artist.name
        self.selectedCity = artist.city
        cityButton.setTitle(artist.city.name, for: .normal)

        self.selectedCountry = artist.country

        priceButton.setTitle(String(artist.price), for: .normal)
        selectedRole = artist.talent
        self.artistTypeLabel.text = artist.talent.description

        loadAllPhotos()

        loadVideoLinks(from: artist.youtubeLinks, doForEachLink: { id in
            self.insertNewVideo(videoId: id)
        })

        loadVideoLinks(from: artist.feedbackLinks, doForEachLink: { id in
            self.insertNewFeedback(videoId: id)
        })
    }

    func loadVideoLinks(from array: [String], doForEachLink: ((String) -> Void)) {
        array.forEach { link in
            let videoId: String?

            if link.contains("="), let lastAfterEqual = link.components(separatedBy: "=").last {
                videoId = lastAfterEqual
            } else if let lastAfterSlash = link.components(separatedBy: "/").last {
                videoId = lastAfterSlash
            } else {
                videoId = nil
            }

            if let id = videoId {
                doForEachLink(id)
            }
        }
    }

    func loadAllPhotos() {
        guard let artist = self.artist else { return }
        
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
        backgroundTapGesture.isEnabled = false
        if textView.text == defaultDescriptionText {
            textView.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        backgroundTapGesture.isEnabled = true
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

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heightCell(atIndex: indexPath.row)
    }

    func heightCell(atIndex: Int) -> CGFloat {
        guard atIndex > 0 else { return UITableView.automaticDimension }

        switch self.screenState {
        case .info:
            if atIndex == 1 {
                return descriptionCellHeight()
            } else {
                return 0
            }

        case .media:
            if atIndex == 2 {
                return UITableView.automaticDimension
            } else {
                return 0
            }

        case .feedback:
            if atIndex == 3 {
                return UITableView.automaticDimension
            } else {
                return 0
            }
        }
    }
}
