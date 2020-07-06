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
    @IBOutlet var topPanelView: UIView!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!

    let maxAnimationDelay: Double = 0.1
    var indexShown = [Int]()
    var artists = [Artist]()
    var filteredArtists = [Artist]()

    var talentForThisScreen: Talent!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTalent()
        setup()
        reloadDataList()
    }

    func setupTalent() {
        if self.navigationController?.restorationIdentifier == "djNavigation" {
            self.navigationItem.title = "DJ"
            self.talentForThisScreen = .dj
        } else if self.navigationController?.restorationIdentifier == "musicNavigation" {
            self.navigationItem.title = "MUSIC"
            self.talentForThisScreen = .music(.piano)
        } else if self.navigationController?.restorationIdentifier == "moderatorNavigation" {
            self.navigationItem.title = "MODERATION"
            self.talentForThisScreen = .moderator
        } else if self.navigationController?.restorationIdentifier == "photoNavigation" {
            self.navigationItem.title = "PHOTO & VIDEO"
            self.talentForThisScreen = .photo(.photo)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GlobalManager.navigation = self.navigationController!

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ProfilesListAppears"), object: nil)
    }

    func applyTheme(theme: Theme) {
        self.view.backgroundColor = theme.backgroundColor
        topPanelView.backgroundColor = theme.backgroundColor
        sortButton.setTitleColor(theme.textColor, for: .normal)
        filterButton.setTitleColor(theme.textColor, for: .normal)
    }
    
    @objc func reloadDataList() {
        ARSLineProgressConfiguration.backgroundViewStyle = .full
        ARSLineProgress.show()
        NetworkManager.loadArtists(completion: { artists, error in
            ARSLineProgress.hide()
            ARSLineProgressConfiguration.backgroundViewStyle = .simple
            if error == nil {
                // Использовать реальный город пользователя
                let artistsForCurrentTab = artists
                    .filter { $0.talent.isGlobalTalentEqual(to: self.talentForThisScreen) }

                artistsForCurrentTab.forEach { $0.adjustPriceForCustomerCity(customerCity: GlobalManager.myUser!.city) }

                self.artists = artistsForCurrentTab
                    .sorted(by: {
                        if GlobalManager.sorting == .lowToHigh {
                            return $0.price < $1.price
                        } else {
                            return $0.price > $1.price
                        }
                })
                self.filterButton.isEnabled = self.artists.count > 1

                self.filteredArtists = self.artists
                self.profilesTableView.reloadData()
            } else {
                //TODO: Show error to user
            }
            UIApplication.shared.endIgnoringInteractionEvents()
        })
    }
    
    func setup() {
        applyTheme(theme: ThemeManager.theme)
        UIApplication.shared.beginIgnoringInteractionEvents()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataList), name: .refreshNamesList, object: nil)

        profilesTableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        profilesTableView.estimatedRowHeight = 396
        profilesTableView.rowHeight = UITableView.automaticDimension
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func sortButtonClicked(_ sender: UIButton) {
        let buttonTitle: String

        if GlobalManager.sorting == .highToLow {
            GlobalManager.sorting = .lowToHigh
            buttonTitle = "Low price to high"
        } else {
            GlobalManager.sorting = .highToLow
            buttonTitle = "High price to low"
        }
        sender.setTitle(buttonTitle, for: .normal)
        self.sortArtists()
        self.profilesTableView.reloadData()
    }
    
    @IBAction func filterButtonClicked(_ sender: Any) {
        let filterNavVC = storyboard?.instantiateViewController(withIdentifier: "FilterContainerVC") as! UINavigationController
        let filterVC = filterNavVC.viewControllers.first as! FilterVC
        
        filterVC.artists = filteredArtists
        
        filterVC.filterChangedBlock = {
            self.filterArtists()
            self.sortArtists()
            self.profilesTableView.reloadData()
        }
        self.navigationController?.pushViewController(filterVC, animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ProfilesListDisappears"), object: nil)
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
        present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
    }
    
    func myUserIfExists(id: String) -> User? {
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
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)

        let detailsVC = profileStoryboard.instantiateViewController(withIdentifier: "NewProfile") as! MyProfileViewController
        let artist = self.filteredArtists[indexPath.row]
        detailsVC.artist = artist
        self.navigationController?.pushViewController(detailsVC, animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ProfilesListDisappears"), object: nil)
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
