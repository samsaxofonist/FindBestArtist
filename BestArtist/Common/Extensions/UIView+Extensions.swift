//
//  UIView+Extensions.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 05.03.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit

extension UIView {
    func drawGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = self.frame
        gradient.colors = [ThemeManager.theme.gradientStartColor.cgColor, ThemeManager.theme.gradientEndColor.cgColor]
        
        let gradientView = UIView(frame: self.frame)
        self.insertSubview(gradientView, at: 0)
        gradientView.layer.addSublayer(gradient)
    }
    func drawGradientDj() {
        let gradient = CAGradientLayer()
        gradient.frame = self.frame
        gradient.colors = [UIColor(red: 7/255, green: 196/255, blue: 210/255, alpha: 1.0).cgColor, UIColor(red: 87/255, green: 158/255, blue: 130/255, alpha: 1.0).cgColor]
        
        let gradientView = UIView(frame: self.frame)
        self.insertSubview(gradientView, at: 0)
        gradientView.layer.addSublayer(gradient)
    }
    func drawGradientMus() {
        let gradient = CAGradientLayer()
        gradient.frame = self.frame
        gradient.colors = [UIColor(red: 0/255, green: 223/255, blue: 21/255, alpha: 1.0).cgColor, UIColor(red: 71/255, green: 93/255, blue: 115/255, alpha: 1.0).cgColor]
        
        let gradientView = UIView(frame: self.frame)
        self.insertSubview(gradientView, at: 0)
        gradientView.layer.addSublayer(gradient)
    }
    func drawGradientFoto() {
        let gradient = CAGradientLayer()
        gradient.frame = self.frame
        gradient.colors = [UIColor(red: 225/255, green: 85/255, blue: 43/255, alpha: 1.0).cgColor, UIColor(red: 143/255, green: 49/255, blue: 84/255, alpha: 1.0).cgColor]
        
        let gradientView = UIView(frame: self.frame)
        self.insertSubview(gradientView, at: 0)
        gradientView.layer.addSublayer(gradient)
    }
    func drawGradientFocus() {
        let gradient = CAGradientLayer()
        gradient.frame = self.frame
        gradient.colors = [UIColor(red: 255/255, green: 155/255, blue: 211/255, alpha: 1.0).cgColor, UIColor(red: 255/255, green: 0/255, blue: 107/255, alpha: 1.0).cgColor]
        
        let gradientView = UIView(frame: self.frame)
        self.insertSubview(gradientView, at: 0)
        gradientView.layer.addSublayer(gradient)
    }
    func drawGradientAnother() {
        let gradient = CAGradientLayer()
        gradient.frame = self.frame
        gradient.colors = [UIColor(red: 252/255, green: 174/255, blue: 0/255, alpha: 1.0).cgColor, UIColor(red: 183/255, green: 56/255, blue: 37/255, alpha: 1.0).cgColor]
        
        let gradientView = UIView(frame: self.frame)
        self.insertSubview(gradientView, at: 0)
        gradientView.layer.addSublayer(gradient)
    }

    func addShadow(shadowColor: UIColor, offSet: CGSize, opacity: Float, shadowRadius: CGFloat, cornerRadius: CGFloat, corners: UIRectCorner, fillColor: UIColor = .white) {

        let shadowLayer = CAShapeLayer()
        let size = CGSize(width: cornerRadius, height: cornerRadius)
        let cgPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size).cgPath //1
        shadowLayer.path = cgPath //2
        shadowLayer.fillColor = fillColor.cgColor //3
        shadowLayer.shadowColor = shadowColor.cgColor //4
        shadowLayer.shadowPath = cgPath
        shadowLayer.shadowOffset = offSet //5
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = shadowRadius
        self.layer.addSublayer(shadowLayer)
    }
}
