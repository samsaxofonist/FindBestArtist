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
    
    @IBInspectable var cornerRadius: Double {
        get {
            return Double(self.layer.cornerRadius)
        }set {
            self.layer.cornerRadius = CGFloat(newValue)
        }
    }
    @IBInspectable var borderWidth: Double {
        get {
            return Double(self.layer.borderWidth)
        }
        set {
            self.layer.borderWidth = CGFloat(newValue)
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
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle("MyTitle", for: .normal)
        setTitleColor(UIColor.blue, for: .normal)
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public var cornerRadius1: CGFloat = 2.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius1
        }
    }
}
