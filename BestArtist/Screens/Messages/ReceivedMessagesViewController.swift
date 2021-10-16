//
//  MessagesViewController.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 31.08.21.
//  Copyright © 2021 kievkao. All rights reserved.
//

import UIKit

class ReceivedMessagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var provider = MessagesProvider()
    var messages = [Message]()

    override func viewDidLoad() {
        super.viewDidLoad()

        provider.getMessages { [weak self] messages in
            self?.messages = messages
            self?.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        
        let message = messages[indexPath.row]
        cell.messageTextLabel.text = message.text
        cell.dateLabel.text = DateFormatter().string(from: message.date)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MessageCell
        
    }
}
