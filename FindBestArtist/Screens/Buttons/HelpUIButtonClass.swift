//
//  HelpUIButtonClass.swift
//  FindBestArtist
//
//  Created by Samus Dimitriy on 12.10.2018.
//  Copyright © 2018 Samus Dimitrij. All rights reserved.
//

import UIKit
@IBDesignable

class HelpUIButtonClass: UIButton {
    
    @IBInspectable var cornerRadius: Double = 0 {
        didSet {
            self.layer.cornerRadius = CGFloat(cornerRadius)
        }
    }
    
    @IBInspectable var borderWidth: Double = 0 {
        didSet {
            self.layer.borderWidth = CGFloat(borderWidth)
        }
    }
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    @IBInspectable var shadowColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    @IBInspectable var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
}
