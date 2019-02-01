//
//  BaseViewController.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 16.12.18.
//  Copyright © 2018 kievkao. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        drawGradient()
    }
    
    func drawGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = self.view.frame
        gradient.colors = [UIColor(red: 4/255, green: 188/255, blue: 210/255, alpha: 1.0).cgColor, UIColor(red: 45/255, green: 74/255, blue: 143/255, alpha: 1.0).cgColor]
        
        let gradientView = UIView(frame: self.view.frame)
        self.view.insertSubview(gradientView, at: 0)
        gradientView.layer.addSublayer(gradient)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
