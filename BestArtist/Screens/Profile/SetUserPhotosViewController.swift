//
//  SetUserPhotosViewController.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 02.03.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit
import ImageSlideshow

class SetUserPhotosViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var slideShow: ImageSlideshow!
    
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SetUserPhotosViewController.didTap))
    var artist: Artist!
    var imagePicker = UIImagePickerController()
    var allPhotos = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        slideShow.addGestureRecognizer(gestureRecognizer)
    }
    
    @IBAction func saveGalery(_ sender: Any) {
        
    }
    
    @IBAction func openGalery(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage, let compressed = selectedImage.compressTo(3) else {
            return
        }
        allPhotos.append(compressed)
        let imageSources = allPhotos.map { ImageSource(image: $0) }
        slideShow.setImageInputs(imageSources)
    }
    
    @objc func didTap() {
        slideShow.presentFullScreenController(from: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextViewController = segue.destination as! SetUserInfoViewController
        nextViewController.artist = artist
        artist.photoGalery = allPhotos
    }
}
