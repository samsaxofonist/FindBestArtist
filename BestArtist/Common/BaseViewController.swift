//
//  BaseViewController.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 16.12.18.
//  Copyright © 2018 kievkao. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var needTabBar: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.drawGradient()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if needTabBar == false {
            self.tabBarController?.tabBar.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}

extension UIView {
    func drawGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = self.frame
        gradient.colors = [UIColor(red: 0/255, green: 179/255, blue: 241/255, alpha: 1.0).cgColor, UIColor(red: 12/255, green: 54/255, blue: 153/255, alpha: 1.0).cgColor]
        
        let gradientView = UIView(frame: self.frame)
        self.insertSubview(gradientView, at: 0)
        gradientView.layer.addSublayer(gradient)
    }
}
