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

class MyProfileViewController: UITableViewController {
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
    
    let imagePicker = UIImagePickerController()
    let viewModel = MyProfileViewModel()
    let talents = ["Singer", "DJ", "Saxophone", "Piano", "Moderation", "Photobox", "Photo", "Video"]
    var selectedRole: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPhotoStuff()
        setCurrentPhoto()
        setupArtistTypeMenu()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        artistTypeMenu.selectRow(0, inComponent: 0)
    }
}

