//
//  OrderContactsViewController.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 06.10.20.
//  Copyright © 2020 kievkao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ARSLineProgress

class OrderContactsViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var streetAndNumberTextField: UITextField!
    @IBOutlet weak var postalCodeTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!

    var addressSearchString: String?

    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Your contacts"
        tableView.tableFooterView = UIView()
        emailTextField.delegate = self
        setupSendButtonValidation()

        LoginManager.getFacebookEmail(completion: { email in
            self.emailTextField.text = email
        })
    }

    func setupSendButtonValidation() {
        let nameValidation = nameTextField.rx.text.orEmpty.map { !$0.isEmpty }
        let lastNameValidation = lastNameTextField.rx.text.orEmpty.map { !$0.isEmpty }
        let emailValidation = emailTextField.rx.text.orEmpty.map { !$0.isEmpty }
        let phoneValidation = phoneTextField.rx.text.orEmpty.map { !$0.isEmpty }
        let streetValidation = streetAndNumberTextField.rx.text.orEmpty.map { !$0.isEmpty }
        let postalCodeValidation = postalCodeTextField.rx.text.orEmpty.map { !$0.isEmpty }
        let cityValidation = cityTextField.rx.text.orEmpty.map { !$0.isEmpty }

        let enableButton = Observable.combineLatest(
            nameValidation,
            lastNameValidation,
            emailValidation,
            phoneValidation,
            streetValidation,
            postalCodeValidation,
            cityValidation
        ) { $0 && $1 && $2 && $3 && $4 && $5 && $6 }
                .share(replay: 1)
        enableButton
                .bind(to: sendButton.rx.isEnabled)
                .disposed(by: disposeBag)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField, let text = textField.text, !text.isEmpty {
            if !text.isValidEmail() {
                self.showError(text: "Entered email is not valid!")
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addressController = segue.destination as! SelectAddressViewController
        addressController.prefilledValue = addressSearchString

        addressController.addressFinishBlock = { address, enteredString in
            self.addressSearchString = enteredString

            self.streetAndNumberTextField.text = address.street + " " + address.streetNumber
            self.postalCodeTextField.text = address.postalCode
            self.cityTextField.text = address.city
            self.streetAndNumberTextField.sendActions(for: .valueChanged)
            self.postalCodeTextField.sendActions(for: .valueChanged)
            self.cityTextField.sendActions(for: .valueChanged)
        }
    }

    @IBAction func sendButtonClicked() {
        let artistsInfos = GlobalManager.selectedArtists.map {
            ArtistOrderInfo(artistId: $0.facebookId, fixedPrice: $0.price)
        }

        let newOrder = Order(
            date: Date(),
            city: self.cityTextField.text!,
            artists: artistsInfos,
            isApproved: false
        )

        ARSLineProgress.show()
        FirebaseManager.sendOrder(order: newOrder, userId: GlobalManager.myUser!.facebookId) {
            ARSLineProgress.hide()
            GlobalManager.selectedArtists.removeAll()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewOrderSent"), object: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
