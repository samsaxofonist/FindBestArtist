//
//  AdminSendMessageViewController.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 31.08.21.
//  Copyright © 2021 kievkao. All rights reserved.
//

import UIKit

class AdminSendMessageViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    var artist: Artist!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Send message"
        
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 2
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.clipsToBounds = true
    }
    
    @IBAction func sendButtonClicked() {
        // send
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let userProfileVC = segue.destination as! MyProfileViewController
        userProfileVC.artist = artist
    }
}
