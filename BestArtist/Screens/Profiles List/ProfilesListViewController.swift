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

enum SectionType {
    case myDatesArtistsHeader
    case myDatesTopArtists
    case myDatesOtherArtists
    case busyDatesArtistsHeader
    case busyDatesTopArtists
    case busyDatesOtherArtists
    case error
}

class ProfilesListViewController: BaseViewController {
    @IBOutlet weak var profilesTableView: UITableView!
    @IBOutlet var listSettingsView: UIView!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var emptyStateImage: UIImageView!
    @IBOutlet weak var settingsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var cartButton: UIBarButtonItem!
    
    let maxAnimationDelay: Double = 0.1
    var indexShown = [Int]()
    var artists = [Artist]()

    var myDatesTopArtists = [Artist]()
    var myDatesOtherArtists = [Artist]()

    var topArtists = [Artist]()
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

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NeedShowTabBar"), object: nil)
    }

    func applyTheme(theme: Theme) {
        self.view.backgroundColor = theme.backgroundColor
        listSettingsView.backgroundColor = theme.backgroundColor
        sortButton.setTitleColor(theme.textColor, for: .normal)
        filterButton.setTitleColor(theme.textColor, for: .normal)
    }

    @objc func reloadTableView() {
        profilesTableView.reloadData()
    }
    
    @objc func reloadDataList() {
        ARSLineProgress.show()
        
        NetworkManager.loadArtists(completion: { artists, error in
            ARSLineProgress.hide()
            if error == nil {
                // Использовать реальный город пользователя
                let artistsForCurrentTab = artists
                    .filter { $0.talent.isGlobalTalentEqual(to: self.talentForThisScreen) }

                artistsForCurrentTab.forEach { $0.adjustPriceForCustomerCity(customerCity: GlobalManager.myUser!.city) }

                if GlobalManager.myUser?.type == .customer  {
                    self.setupMyDatesArtists(from: artistsForCurrentTab)
                    
                    let busyArtists = artistsForCurrentTab.filter {
                        !self.myDatesTopArtists.contains($0) && !self.myDatesOtherArtists.contains($0)
                    }
                    self.setupNormalArtists(from: busyArtists)
                    
                } else {
                    self.setupNormalArtists(from: artistsForCurrentTab)
                    self.filterButton.isEnabled = (self.topArtists.count + self.artists.count) > 1
                }
                
                self.showEmptyStateIfNeeded()
                self.profilesTableView.reloadData()
            } else {
                //TODO: Show error to user
            }
            UIApplication.shared.endIgnoringInteractionEvents()
        })
    }
    
    func setupNormalArtists(from artistsForCurrentTab: [Artist]) {
        self.topArtists = artistsForCurrentTab.filter { $0.rating >= 4 }
        let otherArtists = artistsForCurrentTab.filter { $0.rating < 4 }

        self.artists = otherArtists
            .sorted(by: {
                if GlobalManager.sorting == .lowToHigh {
                    return $0.price < $1.price
                } else {
                    return $0.price > $1.price
                }
        })
        self.filteredArtists = otherArtists
    }
    
    func setupMyDatesArtists(from artistsForCurrentTab: [Artist]) {
        let myEventDates = GlobalManager.myUser!.dates.map { Date(timeIntervalSince1970: $0) }
        
        let artistsForOurDates = artistsForCurrentTab.filter { artist in
            let artistsBusyDays = artist.dates.map { Date(timeIntervalSince1970: $0) }

            return !artistsBusyDays.allSatisfy { oneArtistBusyDate in
                myEventDates.contains(where: { oneMyDate in
                    isSameDay(date1: oneMyDate, date2: oneArtistBusyDate)
                })
            }
        }
        
        self.myDatesTopArtists = artistsForOurDates.filter { $0.rating >= 4 }
        
        if self.myDatesTopArtists.isEmpty {
            self.myDatesTopArtists = artistsForOurDates
            self.myDatesOtherArtists = []
        } else {
            self.myDatesOtherArtists = artistsForOurDates.filter { $0.rating < 4 }
        }
    }
    
    func hasAtLeastOneArtist() -> Bool {
        return !self.myDatesTopArtists.isEmpty ||
            !self.myDatesOtherArtists.isEmpty ||
            !self.topArtists.isEmpty ||
            !self.filteredArtists.isEmpty
    }

    func showEmptyStateIfNeeded() {
        if !hasAtLeastOneArtist() {
            self.emptyStateImage.isHidden = false
            self.setSettingsViewVisible(false)
        } else {
            let totalCount = self.filteredArtists.count + self.topArtists.count
            if totalCount < 3  {
                self.setSettingsViewVisible(false)
            } else {
                self.setSettingsViewVisible(true)
            }
            self.emptyStateImage.isHidden = true
        }
    }

    func setSettingsViewVisible(_ isVisible: Bool) {
        self.listSettingsView.isHidden = !isVisible
        self.settingsViewHeight.constant = isVisible ? 50 : 0
    }
    
    func setup() {
        applyTheme(theme: ThemeManager.theme)
        UIApplication.shared.beginIgnoringInteractionEvents()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataList), name: .refreshNamesList, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: Notification.Name("NewOrderSent"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: Notification.Name("CartClosed"), object: nil)

        profilesTableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        profilesTableView.estimatedRowHeight = 396
        profilesTableView.rowHeight = UITableView.automaticDimension
        profilesTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        profilesTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
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
        
        filterVC.artists = self.artists + self.topArtists
        
        filterVC.filterChangedBlock = {
            self.filterArtists()
            self.sortArtists()
            self.showEmptyStateIfNeeded()
            self.profilesTableView.reloadData()
        }
        self.navigationController?.pushViewController(filterVC, animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NeedHideTabBar"), object: nil)
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
        self.filteredArtists = self.artists

        if let priceFilter = GlobalManager.filterPrice {
            self.filteredArtists = self.filteredArtists.filter {
                if case let FilterType.price(from, up) = priceFilter {
                    return $0.price >= from && $0.price <= up
                } else {
                    // Добавить логику, когда у артиста будет задано расстояние на котором он работает
                    return true
                }
            }
        }

        if let distanceFilter = GlobalManager.filterDistance {
            self.filteredArtists = self.filteredArtists.filter {
                if case let FilterType.distance(center, radius) = distanceFilter {
                    return $0.city.location.distance(from: center) <= radius
                } else {
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
    
    func hasSection(type: SectionType) -> Bool {
        switch type {
        case .myDatesArtistsHeader:
            return !self.myDatesTopArtists.isEmpty || !self.myDatesOtherArtists.isEmpty
        case .myDatesTopArtists:
            return !self.myDatesTopArtists.isEmpty
        case .myDatesOtherArtists:
            return !self.myDatesOtherArtists.isEmpty
        case .busyDatesArtistsHeader:
            return !self.topArtists.isEmpty || !self.filteredArtists.isEmpty
        case .busyDatesTopArtists:
            return !self.topArtists.isEmpty
        case .busyDatesOtherArtists:
            return !self.filteredArtists.isEmpty
        case .error:
            return false
        }
    }
    
    func artist(at indexPath: IndexPath) -> Artist? {
        switch indexPath.section {
        case 0:
            return nil
        case 1:
            if hasSection(type: .myDatesTopArtists) {
                return self.myDatesTopArtists[indexPath.row]
            } else if hasSection(type: .busyDatesTopArtists) {
                return self.topArtists[indexPath.row]
            } else if hasSection(type: .busyDatesOtherArtists) {
                return self.filteredArtists[indexPath.row]
            } else {
                return nil
            }
        case 2:
            if hasSection(type: .myDatesOtherArtists) {
                return self.myDatesOtherArtists[indexPath.row]
            } else if hasSection(type: .busyDatesArtistsHeader) {
                return nil
            } else if hasSection(type: .busyDatesOtherArtists) {
                return self.filteredArtists[indexPath.row]
            } else {
                return nil
            }
        case 3:
            if hasSection(type: .busyDatesArtistsHeader) {
                return nil
            } else if hasSection(type: .busyDatesTopArtists) {
                return self.topArtists[indexPath.row]
            } else {
                return nil
            }
        case 4:
            if hasSection(type: .busyDatesTopArtists) {
                return self.topArtists[indexPath.row]
            } else if hasSection(type: .busyDatesOtherArtists) {
                return self.filteredArtists[indexPath.row]
            } else {
                return nil
            }
        case 5:
            if hasSection(type: .busyDatesOtherArtists) {
                return self.filteredArtists[indexPath.row]
            } else {
                return nil
            }
        default:
            return nil
        }
    }
    
    func getSectionInfo(at section: Int) -> (cellsCount: Int, headerTitle: String, type: SectionType) {
        if section == 0 {
            if hasSection(type: .myDatesArtistsHeader) {
                return (0, "My dates header", .myDatesArtistsHeader)
            } else {
                return (0, "Busy dates header", .busyDatesArtistsHeader)
            }
        }
        
        if section == 1 {
            if hasSection(type: .myDatesTopArtists) {
                return (self.myDatesTopArtists.count, "My dates TOP", .myDatesTopArtists)
            } else if hasSection(type: .busyDatesTopArtists) {
                return (self.topArtists.count, "Busy dates TOP", .busyDatesTopArtists)
            } else if hasSection(type: .busyDatesOtherArtists) {
                return (self.filteredArtists.count, "Busy dates others", .busyDatesOtherArtists)
            } else {
                return (0, "", .error)
            }
        }
        
        if section == 2 {
            if hasSection(type: .myDatesOtherArtists) {
                return (self.myDatesOtherArtists.count, "My dates others", .myDatesOtherArtists)
            } else if hasSection(type: .busyDatesArtistsHeader) {
                return (0, "Busy dates artist", .busyDatesArtistsHeader)
            } else if hasSection(type: .busyDatesOtherArtists) {
                return (self.filteredArtists.count, "Busy dates others", .busyDatesOtherArtists)
            } else {
                return (0, "", .error)
            }
        }
        
        if section == 3 {
            if hasSection(type: .busyDatesArtistsHeader) {
                return (0, "Busy dates artists", .busyDatesArtistsHeader)
            } else if hasSection(type: .busyDatesTopArtists) {
                return (self.topArtists.count, "Busy dates TOP", .busyDatesTopArtists)
            } else {
                return (0, "", .error)
            }
        }
        
        if section == 4 {
            if hasSection(type: .busyDatesTopArtists) {
                return (self.topArtists.count, "Busy dates TOP", .busyDatesTopArtists)
            } else if hasSection(type: .busyDatesOtherArtists) {
                return (self.filteredArtists.count, "Busy dates others", .busyDatesOtherArtists)
            } else {
                return (0, "", .error)
            }
        }
        
        if section == 5 {
            if hasSection(type: .busyDatesOtherArtists) {
                return (self.filteredArtists.count, "Busy dates others", .busyDatesOtherArtists)
            } else {
                return (0, "", .error)
            }
        }
        
        return (0, "", .error)
    }
}

extension ProfilesListViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        
        var sectionsCount = 0
        if hasSection(type: .myDatesArtistsHeader) {
            sectionsCount += 1
        }
        
        if hasSection(type: .myDatesTopArtists) {
            sectionsCount += 1
        }
        
        if hasSection(type: .myDatesOtherArtists) {
            sectionsCount += 1
        }
        
        if hasSection(type: .busyDatesArtistsHeader) {
            sectionsCount += 1
        }
        
        if hasSection(type: .busyDatesTopArtists) {
            sectionsCount += 1
        }
        
        if hasSection(type: .busyDatesOtherArtists) {
            sectionsCount += 1
        }
        return sectionsCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getSectionInfo(at: section).cellsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell

        let artist: Artist
        
        let headerInfo = getSectionInfo(at: indexPath.section)
        
        switch headerInfo.type {
        case .busyDatesOtherArtists:
            artist = self.filteredArtists[indexPath.row]
            cell.isTop = false
        case .busyDatesTopArtists:
            artist = self.topArtists[indexPath.row]
            cell.isTop = true
        case .myDatesOtherArtists:
            artist = self.myDatesOtherArtists[indexPath.row]
            cell.isTop = false
        case .myDatesTopArtists:
            artist = self.myDatesTopArtists[indexPath.row]
            cell.isTop = true
        default:
            return cell
        }

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
        guard let artist = artist(at: indexPath) else { return }
        
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let detailsVC = profileStoryboard.instantiateViewController(withIdentifier: "NewProfile") as! MyProfileViewController
        detailsVC.artist = artist
        self.navigationController?.pushViewController(detailsVC, animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NeedHideTabBar"), object: nil)
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
        return makeHeaderLabel(text: getSectionInfo(at: section).headerTitle)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    func makeHeaderLabel(text: String) -> UIView {
        let containerView = UIView()
        let label = UILabel()
        label.text = text
        label.font = UIFont.boldSystemFont(ofSize: 27)
        label.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(label)

        label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30).isActive = true
        label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true

        return containerView
    }
    
    func wasCellAlreadyPresent(index: IndexPath) -> Bool {
        if indexShown.contains(index.row) {
            return true
        } else {
            return false
        }
    }
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let diff = Calendar.current.dateComponents([.day, .month, .year], from: date1, to: date2)
        if diff.day == 0 && diff.month == 0 && diff.year == 0 {
            return true
        } else {
            return false
        }
    }
}
