//
//  GlobalManager.swift
//  FindBestArtist
//
//  Created by Andrii Kravchenko on 04.11.18.
//  Copyright © 2018 Samus Dimitrij. All rights reserved.
//

import UIKit
import MapKit

enum SortingType {
    case lowToHigh
    case highToLow
    
    var title: String {
        switch self {
        case .lowToHigh:
            return "From cheap to expensive"
        case .highToLow:
            return "From expensive to cheap"
        }
    }
}

enum FilterType {
    case price(from: Int, up: Int)
    case distance(center: CLLocationCoordinate2D, radius: Double)
}

class GlobalManager {
    static var navigation: UINavigationController?
    static var rootNavigation: UINavigationController?
    static var myUser: User?
    static var selectedArtists = [User]()
    static var sorting: SortingType = .lowToHigh
    static var filterPrice: FilterType? = nil
    static var filterDistance: FilterType? = nil
    static var photoFullScreenCloseHandler: (() -> Void)?
}
