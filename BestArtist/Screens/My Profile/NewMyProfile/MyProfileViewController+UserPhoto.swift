//
//  MyProfileViewController+UserPhoto.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 04.07.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit
import CropViewController
import ARSLineProgress
import ImageSlideshow

extension MyProfileViewController {
    
    func setupPhotoStuff() {
        photoImageView.layer.cornerRadius = 100
        photoBackgroundVIew.layer.cornerRadius = 102
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
    }
    
    func setCurrentPhoto() {
        ARSLineProgress.ars_showOnView(photoImageView)
        viewModel.getProfilePhoto { photo in
            ARSLineProgress.hide()
            guard let userPhoto = photo else { return }
            self.photoImageView.image = userPhoto
        }
    }
    
    @IBAction func photoClicked(_ sender: Any) {
        imagePickerForUserPhoto = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func editButtonClicked(_ sender: Any) {
        if let image = photoImageView.image {
            let cropViewController = CropViewController(image: image)
            cropViewController.delegate = self
            present(cropViewController, animated: true, completion: nil)
        }
    }
}

extension MyProfileViewController: CropViewControllerDelegate {
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        photoImageView.image = image
        dismiss(animated: true, completion: nil)
    }
}

extension MyProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        
        guard let selectedImage = info[.originalImage] as? UIImage, let compressed = selectedImage.resized(toWidth: 600) else {
            return
        }
        
        if imagePickerForUserPhoto {
            photoImageView.image = selectedImage.resized(toWidth: 600)
        } else {
            allPhotos.append(compressed)
            let imageSources = allPhotos.map { ImageSource(image: $0) }
            photosSlideShow.setImageInputs(imageSources)
        }
    }
}
