//
//  MyProfileViewController+Description.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 24.07.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit

extension MyProfileViewController {
    
    func setupDescription() {
        if artist.description.isEmpty == false {
            descriptionTextView.text = artist.description
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
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
