//
//  MyProfileViewController+ArtistType.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 04.07.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit
import MKDropdownMenu

extension MyProfileViewController: MKDropdownMenuDelegate, MKDropdownMenuDataSource {
    
    func setupArtistTypeMenu() {
        artistTypeMenu.layer.cornerRadius = 8
    }
    
    func numberOfComponents(in dropdownMenu: MKDropdownMenu) -> Int {
        return 1
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, numberOfRowsInComponent component: Int) -> Int {
        return talents.count
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, titleForComponent component: Int) -> String? {
        dropdownMenu.dropdownBackgroundColor = .white
        dropdownMenu.dropdownCornerRadius = 10
        return selectedRole?.description
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, didSelectRow row: Int, inComponent component: Int) {
        selectedRole = Talent(string: talents[row])
        dropdownMenu.closeAllComponents(animated: true)
        dropdownMenu.reloadAllComponents()
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, titleForRow row: Int, forComponent component: Int) -> String? {
        return talents[row]
    }
}
