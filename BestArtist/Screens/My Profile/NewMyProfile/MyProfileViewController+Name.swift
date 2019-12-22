//
//  MyProfileViewController+Name.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 04.07.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit

extension MyProfileViewController: UITextFieldDelegate {
    
    @IBAction func backgroundClicked(_ sender: Any) {
        view.endEditing(true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        backgroundTapGesture.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        backgroundTapGesture.isEnabled = true
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.contains(" ") {
            view.endEditing(true)
            return false
        } else {
            return true
        }
    }
}

