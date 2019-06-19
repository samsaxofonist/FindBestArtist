//
//  SetUserCityViewController.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 13.01.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit
import MapKit

class SetUserCityViewController: BaseViewController {
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()    
    var artist: Artist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCompleter.delegate = self
    }
}

extension SetUserCityViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {        
        searchCompleter.queryFragment = searchText
    }
}

extension SetUserCityViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
}

extension SetUserCityViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let completion = searchResults[indexPath.row]
        
        Geocoder.getCityAndCountry(locationObject: completion) { city, country in
            let finalViewController = self.storyboard!.instantiateViewController(withIdentifier: "SetUserPriceViewController") as! SetUserPriceViewController
            self.artist.city = city
            self.artist.country = country
            finalViewController.artist = self.artist
            self.navigationController?.pushViewController(finalViewController, animated: true)
        }
    }
}
