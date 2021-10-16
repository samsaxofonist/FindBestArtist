//
//  AdminMessagesManager.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 16.10.21.
//  Copyright © 2021 kievkao. All rights reserved.
//

import Foundation

class AdminMessagesManager {
    
    func loadContactedUsers(completion: (([ContactedUser]) -> Void)) {
        completion([ContactedUser(name: "Ivan", photoLink: nil, cityName: "Munich", messages: [Message(text: "I know this is an old topic but it came up in MY search,\n so the solution here is to set the User Defined Runtime Attribute to a numeric value (in points, so 0.5 would be 1/2 point)", date: Date())])])
    }
}
