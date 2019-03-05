//
//  File.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 16.01.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import Foundation
import UIKit

class Artist  {
    var databaseId: String?
    var facebookId: String = ""
    var name: String = ""
    var talent: String = ""
    var description: String = ""
    var youtubeLink: String = ""
    var city: City!
    var price: Int = 0
    
    var photo: UIImage!
    var photoLink: String!
    
    var photoGalery = [UIImage]()
    var photoGaleryLinks: [String] = []
    var busyDates: [TimeInterval] = []
}
