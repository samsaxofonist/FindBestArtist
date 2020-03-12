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

final class MyProfileViewController: UITableViewController {
    typealias VideoId = String
    
    @IBOutlet weak var photoBackgroundVIew: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var artistTypeMenu: MKDropdownMenu!
    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var photosSlideShow: ImageSlideshow!
    @IBOutlet weak var videosCollectionView: UICollectionView!
    @IBOutlet weak var feedbacksCollectionVIew: UICollectionView!
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var photosTitleLabel: UILabel!
    @IBOutlet weak var videosTitleLabel: UILabel!
    @IBOutlet weak var feedbacksTitleLabel: UILabel!
    @IBOutlet weak var calendarTitleLabel: UILabel!
    @IBOutlet var backgroundTapGesture: UITapGestureRecognizer!
    @IBOutlet weak var artistTypeLabel: UILabel!
    
    var subscriptions = Set<AnyCancellable>()
    
    let defaultDescriptionText = "Artist of the original genre ..."
    let talents: [String] = Talent.allTalents
    let citySegueName = "selectCitySegue"
    let priceSegueName = "selectPriceSegue"

    var artist: Artist!
    
    let imagePicker = UIImagePickerController()
    let viewModel = MyProfileViewModel()
    var selectedRole: Talent?
    var allPhotos: [UIImage] = [UIImage(named: "plusIcon")!]
    var allVideos: [VideoId] = []
    var allFeedbacks: [VideoId] = []
    var selectedDates = [TimeInterval]()
    var selectedCity: City?
    var selectedCountry: String?
    var selectedPrice: Int = 0
    var userPhotoURL: URL?
    
    var imagePickerForUserPhoto = true

    var applyBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        applyTheme(theme: ThemeManager.theme)
        setupInitialInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if GlobalManager.myUser == artist {
            self.applyBarButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(MyProfileViewController.saveButtonClicked))
            self.navigationItem.rightBarButtonItem = applyBarButton
        }
        selectCalendarDates()
        let imageSources = allPhotos.map { ImageSource(image: $0) }
        photosSlideShow.setImageInputs(imageSources)
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
        self.artist.galleryPhotos = self.allPhotos.dropLast()
        self.artist.busyDates = self.selectedDates
        self.artist.feedbackLinks = self.allFeedbacks
        self.artist.photoLink = self.userPhotoURL?.absoluteString ?? artist.photoLink

        ARSLineProgress.show()
        guard let artist = self.artist else { return }
        NetworkManager.saveArtist(artist, finish: {
            ARSLineProgress.hide()
            NotificationCenter.default.post(name: .refreshNamesList, object: nil)
            self.navigationController?.popToRootViewController(animated: true)
        })
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
        editButton.setTitleColor(theme.textColor, for: .normal)
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
