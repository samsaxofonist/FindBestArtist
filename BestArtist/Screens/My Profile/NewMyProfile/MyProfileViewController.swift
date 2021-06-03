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
import Cosmos
import VisualEffectView

final class MyProfileViewController: UITableViewController, UIGestureRecognizerDelegate {
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
    
    @IBOutlet weak var ratingToName: NSLayoutConstraint!
    @IBOutlet weak var ratingToPhoto: NSLayoutConstraint!
    @IBOutlet weak var ratingView: CosmosView!

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

    var photosLongTapRecognizer: UIGestureRecognizer!
    var videosLongTapRecognizer: UIGestureRecognizer!
    var feedbacksLongTapRecognizer: UIGestureRecognizer!
    
    var blur: VisualEffectView!
    
    var mainPhotoChanged = false
    var galleryPhotosChanged = false

    override func viewDidLoad() {
        super.viewDidLoad()

        applyTheme(theme: ThemeManager.theme)
        setupPhotoShadow()
                
        tableView.tableFooterView = UIView()
        
        blur = VisualEffectView(frame: tableView.frame)
        blur.colorTint = .white
        blur.colorTintAlpha = 0.2
        blur.blurRadius = 7
        self.tableView.addSubview(blur)
        blur.isHidden = true
        
        setupSegmentsControl()
        //setupMediasLongTap()
        setupInitialInfo()
        
        if GlobalManager.myUser != artist {
            ratingView.isUserInteractionEnabled = false
        }
    }
    
    func setBlurVisible(_ visible: Bool) {
        blur.isHidden = !visible
    }

    func setupMediasLongTap() {
        photosLongTapRecognizer = makeLongTapGestureRecognizer()
        self.photosCollectionView?.addGestureRecognizer(photosLongTapRecognizer)

        videosLongTapRecognizer = makeLongTapGestureRecognizer()
        self.videosCollectionView?.addGestureRecognizer(videosLongTapRecognizer)

        feedbacksLongTapRecognizer = makeLongTapGestureRecognizer()
        self.feedbacksCollectionVIew?.addGestureRecognizer(feedbacksLongTapRecognizer)
    }

    func makeLongTapGestureRecognizer() -> UILongPressGestureRecognizer {
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(MyProfileViewController.handleLongMediaPress(gestureRecognizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delegate = self
        lpgr.delaysTouchesBegan = true
        lpgr.isEnabled = false
        return lpgr
    }

    @objc func handleLongMediaPress(gestureRecognizer: UILongPressGestureRecognizer){
        if (gestureRecognizer.state != UIGestureRecognizer.State.changed){
            return
        }

        let pointInPhotos = gestureRecognizer.location(in: photosCollectionView)
        if gestureRecognizer.view == photosCollectionView {
            if let indexPath = self.photosCollectionView?.indexPathForItem(at: pointInPhotos) {
                showMediaDeleteAlert(mediaType: "photo", collectionView: photosCollectionView, indexPath: indexPath, confirmDelete: { [unowned self] in
                    self.allPhotos.remove(at: indexPath.row)
                    if self.allPhotos.isEmpty {
                        self.photosLongTapRecognizer.isEnabled = false
                    }
                })
            }
        } else {
            let pointInVideos = gestureRecognizer.location(in: videosCollectionView)
            if gestureRecognizer.view == videosCollectionView {
                if let indexPath = self.videosCollectionView?.indexPathForItem(at: pointInVideos), indexPath.row < self.allVideos.count {
                    showMediaDeleteAlert(mediaType: "video", collectionView: videosCollectionView, indexPath: indexPath, confirmDelete: { [unowned self] in
                        self.allVideos.remove(at: indexPath.row)
                        if self.allVideos.isEmpty {
                            self.videosLongTapRecognizer.isEnabled = false
                        }
                    })
                }
            } else {
                let pointInFeedbacks = gestureRecognizer.location(in: feedbacksCollectionVIew)
                if gestureRecognizer.view == feedbacksCollectionVIew {
                    if let indexPath = self.feedbacksCollectionVIew?.indexPathForItem(at: pointInFeedbacks), indexPath.row < self.allFeedbacks.count {
                        showMediaDeleteAlert(mediaType: "feedback video", collectionView: feedbacksCollectionVIew, indexPath: indexPath, confirmDelete: { [unowned self] in
                            self.allFeedbacks.remove(at: indexPath.row)
                            if self.allFeedbacks.isEmpty {
                                self.feedbacksLongTapRecognizer.isEnabled = false
                            }
                        })
                    }
                }
            }
        }
    }

    func showMediaDeleteAlert(mediaType: String, collectionView: UICollectionView, indexPath: IndexPath, confirmDelete: @escaping () -> ()) {
        let alert = UIAlertController(title: "Do you want to delete \(mediaType)?", message: nil, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            collectionView.performBatchUpdates({
                confirmDelete()
                collectionView.deleteItems(at: [indexPath])
            }, completion:nil)
        }))

        self.present(alert, animated: true)
    }

    private func setupSegmentsControl() {
        segmentsControl.segments = LabelSegment.segments(
            withTitles: ["Info", "Media", "Calendar"],
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
            self.screenState = .calendar
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
        self.artist.dates = self.selectedDates
        self.artist.feedbackLinks = self.allFeedbacks
        self.artist.photoLink = self.userPhotoURL?.absoluteString ?? artist.photoLink

        setBlurVisible(true)
        ARSLineProgress.show()
        guard let artist = self.artist else { return }
        NetworkManager.saveArtist(artist, photoChanged: mainPhotoChanged, galleryPhotosChanged: galleryPhotosChanged, finish: {
            ARSLineProgress.hide()
            self.setBlurVisible(false)
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
