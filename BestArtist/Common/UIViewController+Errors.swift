//
//  UIViewController+Errors.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 23.11.20.
//  Copyright © 2020 kievkao. All rights reserved.
//

import UIKit

extension UIViewController {

    func showError(text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
