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
import Kingfisher
import Combine

extension MyProfileViewController {
    
    func setupPhotoStuff() {
        photoImageView.layer.cornerRadius = 75
        photoBackgroundVIew.layer.cornerRadius = 77
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary

        self.processUserPhotoLinks()
    }

    func processUserPhotoLinks() {
        artist.galleryPhotosLinks.publisher
            .compactMap { URL(string: $0) }
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { url in
                KingfisherManager.shared.retrieveImage(with: ImageResource(downloadURL: url), options: nil, progressBlock: nil) { result in
                    switch result {
                    case .success(let value):
                        self.insertNewPhoto(value.image)
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
            })
            .store(in: &subscriptions)
    }

    func showDeletePhotoAlert() {
        let sheet = UIAlertController(title: "Warning", message: "Delete this photo?", preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Yes, delete", style: .destructive, handler: { _ in
            self.deleteCurrentPhoto()
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(sheet, animated: true, completion: nil)
    }
    
    func deleteCurrentPhoto() {

    }

    @IBAction func longTapOnPhotos(_ sender: Any) {
        showDeletePhotoAlert()
    }

    func openGalery() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    func setCurrentPhoto() {
        ARSLineProgress.ars_showOnView(photoImageView)
        viewModel.getProfilePhoto(artist: artist) { [weak self] photo, url in
            ARSLineProgress.hide()
            guard let userPhoto = photo else { return }
            self?.photoImageView.image = userPhoto
            self?.userPhotoURL = url
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
            insertNewPhoto(compressed)
        }
    }

    func insertNewPhoto(_ photo: UIImage) {
        if allPhotos.count > 0 {
            allPhotos.insert(photo, at: allPhotos.count - 1)
        } else {
            allPhotos.append(photo)
        }
        photosCollectionView.reloadData()
    }
}

extension FullScreenSlideshowViewController {
    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)        
    }
}
