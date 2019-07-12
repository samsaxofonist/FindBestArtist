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
    
    var artist: Artist!
    
    let imagePicker = UIImagePickerController()
    let viewModel = MyProfileViewModel()
    let talents = ["Singer", "DJ", "Saxophone", "Piano", "Moderation", "Photobox", "Photo", "Video"]
    var selectedRole: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPhotoStuff()
        setCurrentPhoto()
        setupArtistTypeMenu()
        showPrice(artist.price)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        artistTypeMenu.selectRow(0, inComponent: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectCitySegue" {
            let cityVC = (segue.destination as! UINavigationController).viewControllers.first as! SelectCityViewController
            setupCityController(cityVC)
        } else if segue.identifier == "selectPriceSegue" {
            let priceVC = (segue.destination as! UINavigationController).viewControllers.first as! SelectPriceViewController
            setupPriceController(priceVC)
        }
    }
    
    func setupCityController(_ controller: SelectCityViewController) {
        controller.finishBlock = { city, country in
            self.cityButton.setTitle(city.name, for: .normal)
        }
    }
}
