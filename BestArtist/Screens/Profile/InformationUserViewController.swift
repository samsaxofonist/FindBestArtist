//
//  InformationUserViewController.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 09.12.18.
//  Copyright © 2018 kievkao. All rights reserved.
//

import UIKit

class InformationUserViewController: WithoutTabbarViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameTitleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var informationAboutYourselfView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        nameTextField.becomeFirstResponder()
    }
    
    @IBAction func hideKeyboardForClicked(_ sender: Any) {
        view.endEditing(true)
    }
    
    @objc func keyBoardWillShow(notification: NSNotification) {
        nameTitleLabelTopConstraint.constant = -200
    }
    
    @objc func keyBoardWillHide(notification: NSNotification) {
        nameTitleLabelTopConstraint.constant = 21
    }
}
