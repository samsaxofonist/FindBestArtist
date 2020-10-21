//
//  SelectAddressViewController.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 10.09.20.
//  Copyright © 2020 kievkao. All rights reserved.
//

import UIKit

class SelectAddressViewController: SelectCityViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    var prefilledValue: String?

    var addressFinishBlock: ((Address, String) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Select address"
        self.searchBar.text = prefilledValue
        self.searchBar(self.searchBar, textDidChange: prefilledValue ?? "")
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let numbersRange = self.searchBar.text!.rangeOfCharacter(from: .decimalDigits)
        let hasNumbers = (numbersRange != nil)

        if hasNumbers {
            return indexPath
        } else {
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let completion = searchResults[indexPath.row]

        Geocoder.getDetailedAddress(locationObject: completion) { address in
            if let address = address {
                self.addressFinishBlock(address, self.searchBar.text!)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
}
