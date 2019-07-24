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
}

class ThemeOlive: Theme {
    var backgroundColor: UIColor = UIColor(rgb: 0x889977)
    var textColor: UIColor = UIColor(rgb: 0xE5E8E9)
    var darkColor: UIColor = UIColor(rgb: 0x333333)
}

class ThemeManager {
    static let theme: Theme = ThemeOlive()
}
