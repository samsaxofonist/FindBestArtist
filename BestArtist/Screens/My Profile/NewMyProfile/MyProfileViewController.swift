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

class MyProfileViewController: UITableViewController, UITextViewDelegate {
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
    
    let defaultDescriptionText = "Artist of the original genre ..."
    let talents = ["Singer", "DJ", "Saxophone", "Piano", "Moderation", "Photobox", "Photo", "Video"]
    let citySegueName = "selectCitySegue"
    let priceSegueName = "selectPriceSegue"
    
    var artist: Artist!
    
    let imagePicker = UIImagePickerController()
    let viewModel = MyProfileViewModel()
    var selectedRole: String?
    var allPhotos: [UIImage] = [UIImage(named: "plusIcon")!]
    var allVideos: [VideoId] = []
    var allFeedbacks: [VideoId] = []
    
    var imagePickerForUserPhoto = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        applyTheme(theme: ThemeManager.theme)
        setupCalendar()
        setupPhotoStuff()
        setCurrentPhoto()
        setupArtistTypeMenu()
        showPrice(artist.price)
        setupDescription()
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
        selectCalendarDates()
        artistTypeMenu.selectRow(0, inComponent: 0)
        let imageSources = allPhotos.map { ImageSource(image: $0) }
        photosSlideShow.setImageInputs(imageSources)
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
            self.cityButton.setTitle(city.name, for: .normal)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row == 1 else { return UITableView.automaticDimension }
        return descriptionCellHeight()
    }
    
    @IBAction func tapOnAddVideo(_ sender: Any) {
        let addVideoNav = self.storyboard?.instantiateViewController(withIdentifier: "AddVideoNavigation") as! UINavigationController
        let addVideoVC = addVideoNav.viewControllers.first as! SetUserVideoViewController
        
        addVideoVC.finishBlock = { videoString in
            if let videoId = videoString {
                self.allVideos.append(videoId)
                self.videosCollectionView.reloadData()
            }
        }
        present(addVideoNav, animated: true, completion: nil)
    }
    
    @IBAction func tapOnAddFeedback(_ sender: Any) {
        let addVideoNav = self.storyboard?.instantiateViewController(withIdentifier: "AddVideoNavigation") as! UINavigationController
        let addVideoVC = addVideoNav.viewControllers.first as! SetUserVideoViewController
        
        addVideoVC.finishBlock = { videoString in
            if let videoId = videoString {
                self.allFeedbacks.append(videoId)
                self.feedbacksCollectionVIew.reloadData()
            }
        }
        present(addVideoNav, animated: true, completion: nil)
    }
    
    @IBAction func longTapOnPhotos(_ sender: Any) {
        showPhotoContextMenu()
    }
    
    func openGalery() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension MyProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let data = getDataArray(for: collectionView)
        return data.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = getDataArray(for: collectionView)
        
        if indexPath.row == data.count {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "AddVideoCell", for: indexPath)
        } else {
            let videoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCell
            
            
            let videoId = data[indexPath.row]
            
            videoCell.playerView.load(withVideoId: videoId)
            return videoCell
        }
    }
    
    func getDataArray(for collectionView: UICollectionView) -> [VideoId] {
        if collectionView == videosCollectionView {
            return allVideos
        } else {
            return allFeedbacks
        }
    }
}
