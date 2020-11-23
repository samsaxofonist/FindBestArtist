//
//  MyOrdersLoader.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 15.10.20.
//  Copyright © 2020 kievkao. All rights reserved.
//

import Foundation

class MyOrdersLoader {

    func loadMyOrders(completion: @escaping (([Order]) -> Void)) {
        FirebaseManager.loadOrders(userId: GlobalManager.myUser!.facebookId, completion: { orders in
            completion(orders)
        })
    }
}
