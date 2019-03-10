//
//  SetProfilePhotoViewController.swift
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
import ImageSlideshow

enum GallerySource {
    case profile
    case photos
}

class SetProfilePhotoViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate {
    @IBOutlet weak var profilePhotoImage: UIImageView!
    @IBOutlet weak var imageToTop: NSLayoutConstraint!
    @IBOutlet weak var backgroundPhotoProfile: UIView!
    
    var imagePicker = UIImagePickerController()
    var artist: Artist!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewComponents()
        loadProfilePhoto()
    }
    
    func setupViewComponents() {
        profilePhotoImage.layer.cornerRadius = 118
        backgroundPhotoProfile.layer.cornerRadius = 120
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
    }
    
    func loadProfilePhoto() {
        ARSLineProgress.ars_showOnView(backgroundPhotoProfile)
        DispatchQueue.global().async {
            FBSDKProfile.loadCurrentProfile { (profile, error) in
                guard let url = FBSDKProfile.current()?.imageURL(for: .normal, size: CGSize(width: 1000, height: 1000)) else { return }
                guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else { return }

                DispatchQueue.main.async {
                    self.profilePhotoImage.image = image.resized(toWidth: 600)
                    ARSLineProgress.hide()
                }
            }
        }
    }
    
    @IBAction func changeProfilePhoto(_ sender: Any) {
        addImageFromGalery()
    }
    
    func addImageFromGalery() {
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
            return
        }
        profilePhotoImage.image = selectedImage.resized(toWidth: 600)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextViewController = segue.destination as! SetUserPhotosViewController
        artist.photo = profilePhotoImage.image
        artist.facebookId = FBSDKProfile.current()?.userID ?? ""
        nextViewController.artist = artist
    }
}
