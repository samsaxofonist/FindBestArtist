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
        photosSlideShow.circular = false
        GlobalManager.photoFullScreenCloseHandler = {
            let imageSources = self.allPhotos.map { ImageSource(image: $0) }
            self.photosSlideShow.setImageInputs(imageSources)
        }
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
    
    @IBAction func tapOnPhotoGallery(_ sender: Any) {
        if photosSlideShow.currentPage == allPhotos.count - 1 {
            imagePickerForUserPhoto = false
            openGalery()
        } else {
            let imageSources = allPhotos.dropLast().map { ImageSource(image: $0) }
            photosSlideShow.setImageInputs(imageSources)
            photosSlideShow.presentFullScreenController(from: self)
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
            allPhotos.insert(compressed, at: 0)
            let imageSources = allPhotos.map { ImageSource(image: $0) }
            photosSlideShow.setImageInputs(imageSources)
        }
    }
}

extension FullScreenSlideshowViewController {
    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        GlobalManager.photoFullScreenCloseHandler?()
    }
}
