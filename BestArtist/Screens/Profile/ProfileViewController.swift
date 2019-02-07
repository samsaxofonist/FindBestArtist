//
//  ProfileViewController.swift
//  FindBestArtist
//
//  Created by Andrii Kravchenko on 04.11.18.
//  Copyright © 2018 Samus Dimitrij. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import CropViewController
import FBSDKLoginKit
import ARSLineProgress

class ProfileViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate {
    @IBOutlet weak var profilePhotoImage: UIImageView!
    @IBOutlet weak var imageToTop: NSLayoutConstraint!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var backgroundPhotoProfile: UIView!
    
    var imagePicker = UIImagePickerController()
    var artist = Artist()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ARSLineProgressConfiguration.backgroundViewStyle = .full
        ARSLineProgress.ars_showOnView(backgroundPhotoProfile)
        loadProfilePhoto()
        profilePhotoImage.layer.cornerRadius = 118
        backgroundPhotoProfile.layer.cornerRadius = 120
    }
    
    func loadProfilePhoto() {
        DispatchQueue.global().async {
            FBSDKProfile.loadCurrentProfile { (profile, error) in
                guard let url = FBSDKProfile.current()?.imageURL(for: .normal, size: CGSize(width: 1000, height: 1000)) else { return }
                guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else { return }

                DispatchQueue.main.async {
                    self.profilePhotoImage.image = image
                    
                    ARSLineProgress.hide()
                }
            }
        }
    }
    
    @IBAction func chooseButtonDidSelected(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func openCropControllerClicked(_ sender: Any) {
        if let image = profilePhotoImage.image {
            let cropViewController = CropViewController(image: image)
            cropViewController.delegate = self
            present(cropViewController, animated: true, completion: nil)
        }
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        profilePhotoImage.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        profilePhotoImage.image = selectedImage
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextViewController = segue.destination as! InformationUserViewController
        artist.photo = profilePhotoImage.image
        artist.facebookId = FBSDKProfile.current()?.userID ?? ""
        nextViewController.artist = artist
    }
}
