//
//  SetUserInfoViewController.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 09.12.18.
//  Copyright © 2018 kievkao. All rights reserved.
//

import UIKit
import MKDropdownMenu

class SetUserInfoViewController: BaseViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameTitleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var informationAboutYourselfView: UITextView!
    @IBOutlet weak var numberCharactersLabel: UILabel!
    @IBOutlet weak var numberNameLabel: UILabel!
    @IBOutlet weak var talentArtist: MKDropdownMenu!
    
    let talents = ["Singer", "DJ", "Saxophone", "Piano", "Moderation", "Photobox", "Photo", "Video"]
    var selectedRole: String?
    var artist: Artist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        talentArtist.selectRow(0, inComponent: 0)
    }
    
    @IBAction func hideKeyboardForClicked(_ sender: Any) {
        view.endEditing(true)
    }
    
    @objc func keyBoardWillHide(notification: NSNotification) {
        nameTitleLabelTopConstraint.constant = 21
        UIView.animate(withDuration: 0.35) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextViewController = segue.destination as! SetUserVideoViewController
        artist.name = nameTextField.text ?? ""
        artist.talent = selectedRole ?? ""
        artist.description = informationAboutYourselfView.text
        nextViewController.artist = artist
    }
}

extension SetUserInfoViewController {
    func setup() {
        setupNotifications()
        setupTextFields()
        selectedRole = artist.talent
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupTextFields() {
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
        nameTextField.becomeFirstResponder()
        nameTextField.delegate = self
        nameTextField.text = artist.name
        
        informationAboutYourselfView.delegate = self
        informationAboutYourselfView.text = "Artist of the original genre ..."
        informationAboutYourselfView.textColor = UIColor.lightGray
        informationAboutYourselfView.text = artist.description
    }
    
    func updateInfoCharacterCount() {
        let numberCharacters = self.informationAboutYourselfView.text.count
        self.numberCharactersLabel.text = "\((0) + numberCharacters)/500"
    }
    
    func updateNameCharacterCount() {
        let numberCharacters = self.nameTextField.text?.count ?? 0
        self.numberNameLabel.text = "\((0) + numberCharacters)/10"
    }
}

extension SetUserInfoViewController: MKDropdownMenuDelegate, MKDropdownMenuDataSource {
    
    func numberOfComponents(in dropdownMenu: MKDropdownMenu) -> Int {
        return 1
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, numberOfRowsInComponent component: Int) -> Int {
        return talents.count
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, titleForComponent component: Int) -> String? {
        dropdownMenu.dropdownBackgroundColor = .white
        dropdownMenu.dropdownCornerRadius = 10
        return selectedRole
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, didSelectRow row: Int, inComponent component: Int) {
        selectedRole = talents[row]
        dropdownMenu.closeAllComponents(animated: true)
        dropdownMenu.reloadAllComponents()
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, titleForRow row: Int, forComponent component: Int) -> String? {
        return talents[row]
    }
}

extension SetUserInfoViewController: UITextFieldDelegate {
    
    @objc func textFieldDidChange(sender textField: UITextField) {
        self.updateNameCharacterCount()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let numberSymbolsBefore = textField.text?.count ?? 0
        let numberSymbolToAdd = string.count - range.length
        return numberSymbolsBefore + numberSymbolToAdd <= 10
    }
}

extension SetUserInfoViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        self.updateInfoCharacterCount()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        let numberSymbolsBefore = textView.text.count
        let numberSymbolToAdd = text.count - range.length
        return numberSymbolsBefore + numberSymbolToAdd <= 500
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        nameTitleLabelTopConstraint.constant = -100
        UIView.animate(withDuration: 0.35) {
            self.view.layoutIfNeeded()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Artist of the original genre ..."
            textView.textColor = UIColor.lightGray
        }
    }
}
