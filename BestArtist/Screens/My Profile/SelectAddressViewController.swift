//
//  SelectAddressViewController.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 10.09.20.
//  Copyright © 2020 kievkao. All rights reserved.
//

import UIKit

class SelectAddressViewController: SelectCityViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let completion = searchResults[indexPath.row]

        Geocoder.getDetailedAddress(locationObject: completion) { address in
            if let address = address {
                // 
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
}
