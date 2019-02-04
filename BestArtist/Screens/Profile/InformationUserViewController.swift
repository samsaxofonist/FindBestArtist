//
//  InformationUserViewController.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 09.12.18.
//  Copyright © 2018 kievkao. All rights reserved.
//

import UIKit

class InformationUserViewController: BaseViewController, UITextViewDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameTitleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var talent: UITextField!
    @IBOutlet weak var informationAboutYourselfView: UITextView!
    @IBOutlet weak var numberCharactersLabel: UILabel!
    @IBOutlet weak var numberNameLabel: UILabel!
    
    var artist: Artist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        nameTextField.becomeFirstResponder()
        informationAboutYourselfView.delegate = self
       
        informationAboutYourselfView.text = "Artist of the original genre ..."
        informationAboutYourselfView.textColor = UIColor.lightGray
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
    
    func updateCharacterCount() {
        let numberCharacters = self.informationAboutYourselfView.text.count
        self.numberCharactersLabel.text = "\((0) + numberCharacters)/500"
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.updateCharacterCount()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if(textView == informationAboutYourselfView){
            return textView.text.count +  (text.count - range.length) <= 50
        } else {
            return false
        }        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextViewController = segue.destination as! GetVideoViewController
        artist.name = nameTextField.text ?? ""
        artist.talent = talent.text ?? ""
        artist.description = informationAboutYourselfView.text
        nextViewController.artist = artist
    }
}
