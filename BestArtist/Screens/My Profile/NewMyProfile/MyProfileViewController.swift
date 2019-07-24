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
    
    let defaultDescriptionText = "Artist of the original genre ..."
    let talents = ["Singer", "DJ", "Saxophone", "Piano", "Moderation", "Photobox", "Photo", "Video"]
    let citySegueName = "selectCitySegue"
    let priceSegueName = "selectPriceSegue"
    
    var artist: Artist!
    
    let imagePicker = UIImagePickerController()
    let viewModel = MyProfileViewModel()
    var selectedRole: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        applyTheme(theme: ThemeManager.theme)
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
        artistTypeMenu.selectRow(0, inComponent: 0)
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
}

extension MyProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
