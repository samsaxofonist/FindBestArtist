//
//  ArtistDetailsViewController.swift
//  BestArtist
//
//  Created by Dima on 12.02.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit
import Kingfisher
import ImageSlideshow
import KDCalendar

class ArtistDetailsViewController: UITableViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIView!
    @IBOutlet weak var artistPhotoImageView: UIImageView!
    @IBOutlet weak var calendar: CalendarView!
    @IBOutlet weak var infoArtistLabel: UILabel!
    @IBOutlet weak var slideShow: ImageSlideshow!
    @IBOutlet weak var cityLabel: UILabel!
    
    var selectedArtist: Artist!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewComponents()
        setupWithArtist(selectedArtist)
        
        // Поместить в setupWithArtist, когда будем отображать реальные изображения из галереи
       // let sources = [ImageSource(image: images[0]!), ImageSource(image: images[1]!), ImageSource(image: images[2]!), ImageSource(image: images[3]!), ImageSource(image: images[4]!)]
       // slideShow.setImageInputs(sources)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let today = Date()
        setupCalender()
        calendar.setDisplayDate(today, animated: false)
        
        for timeInterval in selectedArtist.busyDates {
            calendar.selectDate(Date(timeIntervalSince1970: timeInterval))
        }
    }
    
    func setupViewComponents() {
        artistPhotoImageView.layer.cornerRadius = 100
        backgroundImageView.layer.cornerRadius = 102
        tableView.rowHeight = UITableView.automaticDimension
        calendar.marksWeekends = true
        calendar.dataSource = self
    }
    
    func setupCalender() {
        CalendarView.Style.cellShape                = .bevel(4.0)
        CalendarView.Style.cellEventColor = UIColor.brown
        CalendarView.Style.cellTextColorWeekend = UIColor(red:1.00, green:0.63, blue:0.24, alpha:1.00)
    //    CalendarView.Style.cellColorDefault         = UIColor.clear
    //    CalendarView.Style.cellColorToday           = UIColor(red:93, green:253, blue:253, alpha:1.00)
        CalendarView.Style.cellSelectedBorderColor  = UIColor(red:89/255, green:254/255, blue:254/255, alpha:1.00)
    //    CalendarView.Style.cellEventColor           = UIColor.black
        CalendarView.Style.headerTextColor          = UIColor.white
    // CalendarView.Style.cellTextColorDefault     = UIColor.white
    //  CalendarView.Style.cellTextColorToday       = UIColor(red:0.31, green:0.44, blue:0.47, alpha:1.00)
    }
    
    func setupPhoto() {
        if let photoLinkString = selectedArtist.photoLink, let photoURL = URL(string: photoLinkString) {
            artistPhotoImageView.kf.setImage(with: ImageResource(downloadURL: photoURL))
            infoArtistLabel.text = selectedArtist.description
            cityLabel.text? = selectedArtist.city.name
        }
    }
    
    func setupWithArtist(_ artist: Artist) {
        nameLabel.text = artist.name
        //priceLabel.text = String(artist.price)
        infoArtistLabel.text = artist.description
        setupPhoto()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ArtistDetailsViewController: CalendarViewDataSource {
    func startDate() -> Date {
        return Date()
    }
    
    func endDate() -> Date {
        return Calendar.current.date(byAdding: .year, value: 2, to: Date())!
    }
}
