//
//  MyProfileViewController.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 30.06.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit
import MKDropdownMenu
import ImageSlideshow
import KDCalendar
import CropViewController
import ARSLineProgress
import Combine
import BetterSegmentedControl

final class MyProfileViewController: UITableViewController {
    typealias VideoId = String
    
    @IBOutlet weak var photoBackgroundVIew: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var artistTypeMenu: MKDropdownMenu!
    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var videosCollectionView: UICollectionView!
    @IBOutlet weak var feedbacksCollectionVIew: UICollectionView!
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var photosTitleLabel: UILabel!
    @IBOutlet weak var videosTitleLabel: UILabel!
    @IBOutlet weak var feedbacksTitleLabel: UILabel!
    @IBOutlet weak var calendarTitleLabel: UILabel!
    @IBOutlet var backgroundTapGesture: UITapGestureRecognizer!
    @IBOutlet weak var artistTypeLabel: UILabel!
    @IBOutlet weak var segmentsControl: BetterSegmentedControl!
    @IBOutlet weak var photosCollectionView: UICollectionView!

    let slideShow = ImageSlideshow()

    var screenState: ProfileScreenState = .info

    var subscriptions = Set<AnyCancellable>()
    
    let defaultDescriptionText = "Artist of the original genre ..."
    let talents: [String] = Talent.allTalents
    let citySegueName = "selectCitySegue"
    let priceSegueName = "selectPriceSegue"

    var artist: Artist!
    
    let imagePicker = UIImagePickerController()
    let viewModel = MyProfileViewModel()
    var selectedRole: Talent?
    var allPhotos = [UIImage]()
    var allVideos: [VideoId] = []
    var allFeedbacks: [VideoId] = []
    var selectedDates = [TimeInterval]()
    var selectedCity: City?
    var selectedCountry: String?
    var selectedPrice: Int = 0
    var userPhotoURL: URL?
    
    var imagePickerForUserPhoto = true
    var applyBarButton: UIBarButtonItem!

    var isNewProfile = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        applyTheme(theme: ThemeManager.theme)
        setupPhotoShadow()
        tableView.tableFooterView = UIView()
        setupSegmentsControl()
        setupInitialInfo()
    }

    func setupPhotoShadow() {
        photoBackgroundVIew.addShadow(
            shadowColor: UIColor.lightGray,
            offSet: .zero,
            opacity: 0.8,
            shadowRadius: 2,
            cornerRadius: 77,
            corners: .allCorners
        )
    }

    private func setupSegmentsControl() {
        segmentsControl.segments = LabelSegment.segments(
            withTitles: ["Info", "Media", "Feedbacks"],
            normalTextColor: UIColor(rgb: 0x919191),
            selectedTextColor: UIColor(rgb: 0x363636)
        )
        segmentsControl.indicatorViewBorderWidth = 2
        segmentsControl.indicatorViewBorderColor = UIColor(rgb: 0xFB5324)
        segmentsControl.layer.shadowColor = UIColor.lightGray.cgColor
        segmentsControl.layer.shadowOpacity = 0.1
        segmentsControl.layer.shadowOffset = CGSize(width: 0, height: 5)
        segmentsControl.layer.shadowRadius = 2
        segmentsControl.clipsToBounds = false
    }

    @IBAction func segmentSelected(_ sender: BetterSegmentedControl) {
        switch sender.index {
        case 0:
            self.screenState = .info
        case 1:
            self.screenState = .media
        case 2:
            self.screenState = .feedback
        default:
            return
        }
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isNewProfile {
            navigationController?.isNavigationBarHidden = true
        }
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if GlobalManager.myUser == artist {
            self.applyBarButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(MyProfileViewController.saveButtonClicked))
            self.navigationItem.rightBarButtonItem = applyBarButton
        }
        selectCalendarDates()
        photosCollectionView.reloadData()
    }

    func setupInitialInfo() {
        showInitialArtistInfo()
        setupCalendar()
        setupPhotoStuff()
        setCurrentPhoto()
        setupArtistTypeMenu()
    }

    @objc func saveButtonClicked() {
        guard let role = self.selectedRole,
            let name = self.nameTextField.text,
            let description = self.descriptionTextView.text,
            !self.allVideos.isEmpty,
            let city = self.selectedCity,
            let country = self.selectedCountry,
            self.selectedPrice > 0,
            let photo = self.photoImageView.image,
            !self.allPhotos.isEmpty else {
                let errorAlert = UIAlertController(title: "Error", message: "Fill all fields!", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            return
        }

        self.artist.talent = role
        self.artist.name = name
        self.artist.description = description
        self.artist.youtubeLinks = self.allVideos
        self.artist.city = city
        self.artist.country = country
        self.artist.price = self.selectedPrice
        self.artist.photo = photo
        self.artist.galleryPhotos = self.allPhotos
        self.artist.busyDates = self.selectedDates
        self.artist.feedbackLinks = self.allFeedbacks
        self.artist.photoLink = self.userPhotoURL?.absoluteString ?? artist.photoLink

        ARSLineProgress.show()
        guard let artist = self.artist else { return }
        NetworkManager.saveArtist(artist, finish: {
            ARSLineProgress.hide()
            NotificationCenter.default.post(name: .refreshNamesList, object: nil)

            if self.isNewProfile {
                self.createAndOpenMainScreen()
            } else {
                self.navigationController?.popToRootViewController(animated: true)
            }
        })
    }

    func createAndOpenMainScreen() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBar = mainStoryboard.instantiateViewController(withIdentifier: "MainTabBarController")
        self.navigationController?.setViewControllers([mainTabBar], animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == citySegueName {
            let cityVC = (segue.destination as! UINavigationController).viewControllers.first as! SelectCityViewController
            setupCityController(cityVC)
        } else if segue.identifier == priceSegueName {
            let priceVC = (segue.destination as! UINavigationController).viewControllers.first as! SelectPriceViewController
            setupPriceController(priceVC)
        }
    }

    func applyTheme(theme: Theme) {
        tableView.backgroundColor = theme.backgroundColor
        cityButton.setTitleColor(theme.textColor, for: .normal)
        priceButton.setTitleColor(theme.textColor, for: .normal)
        nameTextField.textColor = theme.textColor
        descriptionTextView.textColor = theme.darkColor
        artistTypeMenu.dropdownBackgroundColor = theme.backgroundColor
        artistTypeMenu.tintColor = theme.darkColor
        photosTitleLabel.textColor = theme.textColor
        videosTitleLabel.textColor = theme.textColor
        feedbacksTitleLabel.textColor = theme.textColor
        calendarTitleLabel.textColor = theme.textColor
        navigationController?.navigationBar.barTintColor = theme.backgroundColor
        navigationController?.navigationBar.tintColor = theme.textColor
        CalendarDecorator.decorateCalendar()
    }
    
    func setupCityController(_ controller: SelectCityViewController) {
        controller.finishBlock = { city, country in
            self.selectedCity = city
            self.selectedCountry = country
            self.cityButton.setTitle(city.name, for: .normal)
        }
    }
}
