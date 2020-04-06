//
//  Theme.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 24.07.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit

protocol Theme {
    var backgroundColor: UIColor { get }
    var textColor: UIColor { get }
    var darkColor: UIColor { get }
    var gradientStartColor: UIColor { get }
    var gradientEndColor: UIColor { get }
}

class ThemeOlive: Theme {
    var backgroundColor: UIColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
    var textColor: UIColor = UIColor(rgb: 0x8996A7)
    var darkColor: UIColor = UIColor(rgb: 0x404040)
    var gradientStartColor: UIColor = UIColor(red: 0/255, green: 179/255, blue: 241/255, alpha: 1.0)
    var gradientEndColor: UIColor = UIColor(red: 12/255, green: 54/255, blue: 153/255, alpha: 1.0)
}

class ThemeManager {
    static let theme: Theme = ThemeOlive()
}
