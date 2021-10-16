//
//  AdminMessagesListViewController.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 16.10.21.
//  Copyright © 2021 kievkao. All rights reserved.
//

import UIKit

class AdminMessagesListViewController: UITableViewController {
    
    var messages: [Message]!
    var expanded = [IndexPath]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        self.title = "Messages"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        cell.configure(with: messages[indexPath.row], isExpanded: expanded.firstIndex(of: indexPath) != nil)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let indexOfExpanded = expanded.firstIndex(of: indexPath) {
            expanded.remove(at: indexOfExpanded)
        } else {
            expanded.append(indexPath)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
