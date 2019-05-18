//
//  FullScreenImageVC.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 19.04.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit

class FullScreenImageVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }

    @IBAction func viewClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
