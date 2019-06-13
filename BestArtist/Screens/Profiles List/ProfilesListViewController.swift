//
//  ProfilesListViewController.swift
//  FindBestArtist
//
//  Created by Andrii Kravchenko on 20.10.18.
//  Copyright © 2018 Samus Dimitrij. All rights reserved.
//

import UIKit
import SideMenu
import Firebase
import FirebaseDatabase
import FBSDKCoreKit
import ARSLineProgress

class ProfilesListViewController: BaseViewController {
    @IBOutlet weak var profilesTableView: UITableView!
    @IBOutlet var listSettingsView: UIView!
    
    let maxAnimationDelay: Double = 0.1
    var indexShown = [Int]()
    var artists = [Artist]()
    var filteredArtists = [Artist]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.beginIgnoringInteractionEvents()
        setup()
        reloadDataList()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataList), name: .refreshNamesList, object: nil)
    }
    
    @objc func reloadDataList() {
        ARSLineProgressConfiguration.backgroundViewStyle = .full
        ARSLineProgress.show()
        NetworkManager.loadArtists(completion: { artists, error in
            ARSLineProgress.hide()
            ARSLineProgressConfiguration.backgroundViewStyle = .simple
            if error == nil {
                self.artists = artists.sorted(by: {
                    if GlobalManager.sorting == .lowToHigh {
                        return $0.price < $1.price
                    } else {
                        return $0.price > $1.price
                    }
                })
                self.filteredArtists = self.artists
                self.profilesTableView.reloadData()
                let idUser = FBSDKAccessToken.current()?.userID ?? ""
                let myUser = self.myUserIfExists(id: idUser)
                GlobalManager.myUser = myUser                
            } else {
                //TODO: Show error to user
            }
            UIApplication.shared.endIgnoringInteractionEvents()
        })
    }
    
    func setup() {
        needTabBar = true
        profilesTableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        profilesTableView.estimatedRowHeight = 396
        profilesTableView.rowHeight = UITableView.automaticDimension
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        GlobalManager.navigation = self.navigationController!
    }
    
    @IBAction func sortButtonClicked(_ sender: Any) {
        let sortVC = storyboard?.instantiateViewController(withIdentifier: "sortVC") as! SortVC
        sortVC.sortingChangedBlock = {
            self.sortArtists()
            self.profilesTableView.reloadData()
        }
        present(sortVC, animated: true, completion: nil)
    }
    
    @IBAction func filterButtonClicked(_ sender: Any) {
        let filterVC = storyboard?.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        filterVC.artists = filteredArtists
        
        filterVC.filterChangedBlock = {
            self.filterArtists()
            self.sortArtists()
            self.profilesTableView.reloadData()
        }
        present(filterVC, animated: true, completion: nil)
    }
    
    func sortArtists() {
        self.filteredArtists = self.filteredArtists.sorted(by: {
            if GlobalManager.sorting == .lowToHigh {
                return $0.price < $1.price
            } else {
                return $0.price > $1.price
            }
        })
    }
    
    func filterArtists() {
        if GlobalManager.filterPrice == nil {
            self.filteredArtists = self.artists
        } else {
            self.filteredArtists = self.artists.filter {
                if case let FilterType.price(from, up) = GlobalManager.filterPrice! {
                    return $0.price >= from && $0.price <= up
                } else {
                    // Добавить логику, когда у артиста будет задано расстояние на котором он работает
                    return true
                }
            }
        }
    }
    
    @objc func menuButtonClicked() {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    func myUserIfExists(id: String) -> Artist? {
        return artists.filter({ $0.facebookId == id }).first
    }
}

extension ProfilesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredArtists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        let artist = self.filteredArtists[indexPath.row]
        cell.setupWithArtist(artist)
        cell.onClickBlock = {
            let index = GlobalManager.selectedArtists.firstIndex(of: artist)            
            if index != nil {
                GlobalManager.selectedArtists.remove(at: index!)
            } else {
                GlobalManager.selectedArtists.append(artist)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = self.storyboard?.instantiateViewController(withIdentifier: "detailsContainer") as! ArtistDetailsContainerController
        let artist = self.filteredArtists[indexPath.row]
        detailsVC.selectedArtist = artist
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard !wasCellAlreadyPresent(index: indexPath) else {return}
        cell.layoutIfNeeded()
        let originalY = cell.frame.origin.y
        cell.frame.origin = CGPoint(x: -UIScreen.main.bounds.width, y: originalY)
        cell.alpha = 0
        
        let delay = Double(indexPath.row) * 0.05
        let finalDelay = delay < maxAnimationDelay ? delay : maxAnimationDelay
        
        UIView.animate(withDuration: 0.6, delay: finalDelay, options: [], animations: {
            cell.frame.origin = CGPoint(x: 0, y: originalY)
            cell.alpha = 1
        }, completion: nil)
        indexShown.append(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return listSettingsView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func wasCellAlreadyPresent(index: IndexPath) -> Bool {
        if indexShown.contains(index.row) {
            return true
        } else {
            return false
        }
    }
}
