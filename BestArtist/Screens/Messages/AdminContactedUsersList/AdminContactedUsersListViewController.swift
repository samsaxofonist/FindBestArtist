//
//  AdminContactedUsersListViewController.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 16.10.21.
//  Copyright © 2021 kievkao. All rights reserved.
//

import UIKit

class AdminContactedUsersListViewController: UITableViewController {
    
    let manager = AdminMessagesManager()
    var contactedUsers = [ContactedUser]()
    
    // Не надо ничего загружать - сообщения уже внутри User

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        tableView.tableFooterView = UIView()
        self.title = "Contacted users"
        
        manager.loadContactedUsers { [weak self] contactedUsers in
            self?.contactedUsers = contactedUsers
            self?.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactedUsers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        cell.setupWithContactedUser(contactedUsers[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let messages = contactedUsers[indexPath.row].messages
        let messagesListController = self.storyboard?.instantiateViewController(identifier: "AdminMessagesListViewController") as! AdminMessagesListViewController
        messagesListController.messages = messages
        self.navigationController?.pushViewController(messagesListController, animated: true)
    }
}
