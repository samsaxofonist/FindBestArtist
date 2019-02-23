//
//  InformationUserViewController.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 09.12.18.
//  Copyright © 2018 kievkao. All rights reserved.
//

import UIKit
import MKDropdownMenu

class InformationUserViewController: BaseViewController, UITextViewDelegate, UITextFieldDelegate, MKDropdownMenuDelegate, MKDropdownMenuDataSource {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameTitleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var informationAboutYourselfView: UITextView!
    @IBOutlet weak var numberCharactersLabel: UILabel!
    @IBOutlet weak var numberNameLabel: UILabel!
    @IBOutlet weak var talentArtist: MKDropdownMenu!
    
    let talents = ["Dancer", "Singer", "DJ"]
    var selectedRole: String?
    
    var artist: Artist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
        
        nameTextField.becomeFirstResponder()
        informationAboutYourselfView.delegate = self
        nameTextField.delegate = self
       
        informationAboutYourselfView.text = "Artist of the original genre ..."
        informationAboutYourselfView.textColor = UIColor.lightGray
        
        nameTextField.text = artist.name
        informationAboutYourselfView.text = artist.description
        selectedRole = artist.talent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        talentArtist.selectRow(0, inComponent: 0)
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Artist of the original genre ..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    func updateInfoCharacterCount() {
        let numberCharacters = self.informationAboutYourselfView.text.count
        self.numberCharactersLabel.text = "\((0) + numberCharacters)/500"
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.updateInfoCharacterCount()
    }
    
    func updateNameCharacterCount() {
        let numberCharacters = self.nameTextField.text?.count ?? 0
        self.numberNameLabel.text = "\((0) + numberCharacters)/10"
    }
    
    @objc func textFieldDidChange(sender textField: UITextField) {
        self.updateNameCharacterCount()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        let numberSymbolsBefore = textView.text.count
        let numberSymbolToAdd = text.count - range.length
        return numberSymbolsBefore + numberSymbolToAdd <= 500
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let numberSymbolsBefore = textField.text?.count ?? 0
        let numberSymbolToAdd = string.count - range.length
        return numberSymbolsBefore + numberSymbolToAdd <= 10
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextViewController = segue.destination as! GetVideoViewController
        artist.name = nameTextField.text ?? ""
        artist.talent = selectedRole ?? ""
        artist.description = informationAboutYourselfView.text
        nextViewController.artist = artist
    }
}
