//
//  GradientView.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 31.01.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit

class GradientView: UIView {
    var gradient = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        drawGradient()
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = self.bounds
    }
    
    func drawGradient() {
        gradient.frame = self.bounds
        gradient.colors = [UIColor(red: 198/255, green: 244/255, blue: 249/255, alpha: 1.0).cgColor, UIColor(red: 26/255, green: 126/255, blue: 192/255, alpha: 1.0).cgColor]
        self.layer.addSublayer(gradient)
    }
}
