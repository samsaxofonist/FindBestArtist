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
import JTAppleCalendar

class ArtistDetailsViewController: UITableViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIView!
    @IBOutlet weak var artistPhotoImageView: UIImageView!
    var selectedArtist: Artist!
    @IBOutlet weak var calendar: JTAppleCalendarView!
    
    @IBOutlet weak var infoArtistLabel: UILabel!
    @IBOutlet weak var slideShow: ImageSlideshow!
    let images = [UIImage(named: "p1"), UIImage(named: "p2"), UIImage(named: "p3"), UIImage(named: "p4"), UIImage(named: "p5")]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        setupWithArtist(selectedArtist)
        if let photoLinkString = selectedArtist.photoLink, let photoURL = URL(string: photoLinkString) {
            artistPhotoImageView.kf.setImage(with: ImageResource(downloadURL: photoURL))
            artistPhotoImageView.layer.cornerRadius = 100
            backgroundImageView.layer.cornerRadius = 102
            infoArtistLabel.text = selectedArtist.description
        }
        
        let sources = [ImageSource(image: images[0]!), ImageSource(image: images[1]!), ImageSource(image: images[2]!), ImageSource(image: images[3]!), ImageSource(image: images[4]!)]
        slideShow.setImageInputs(sources)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ArtistDetailsViewController.didTap))
        slideShow.addGestureRecognizer(gestureRecognizer)
    }
    
    func setupCalendar() {
        calendar.minimumLineSpacing = 0
        calendar.minimumInteritemSpacing = 0
        calendar.allowsMultipleSelection = true
        calendar.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0 )
        calendar.cellSize = CalendarCell.cellSize
    }
    
    func setupWithArtist(_ artist: Artist) {
        nameLabel.text = artist.name
        //priceLabel.text = String(artist.price)
        infoArtistLabel.text = artist.description
    }
    
    @objc func didTap() {
        slideShow.presentFullScreenController(from: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ArtistDetailsViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let startDate = Date()
        let yearToAdd = 2
        guard let endDate = Calendar.current.date(byAdding: .year, value: yearToAdd, to: startDate) else { fatalError("Calendar out of bounds") }
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 generateOutDates: .tillEndOfRow,
                                                 firstDayOfWeek: DaysOfWeek(rawValue: Calendar.current.firstWeekday) ?? .sunday)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        guard let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: CalendarCell.identifier, for: indexPath) as? CalendarCell else { fatalError("Calendar cell not dequed") }
        cell.dateLabel.text = cellState.text
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
    }
}
