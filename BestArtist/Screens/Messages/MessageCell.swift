//
//  MessageCell.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 31.08.21.
//  Copyright © 2021 kievkao. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var dateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        return formatter
    }()
    
    func configure(with message: Message, isExpanded: Bool) {
        messageTextLabel.text = message.text
        dateLabel.text = dateTimeFormatter.string(from: message.date)
        messageTextLabel.numberOfLines = isExpanded ? 0 : 2
    }    
}
