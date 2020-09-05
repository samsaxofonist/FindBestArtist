//
//  MyProfileViewController+Videos.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 22.12.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit
import ImageSlideshow

extension MyProfileViewController {

    func deleteCurrentVideo() {
        let visibleRect = CGRect(origin: videosCollectionView.contentOffset, size: videosCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let visibleIndexPath = videosCollectionView.indexPathForItem(at: visiblePoint) else { return }
        self.allVideos.remove(at: visibleIndexPath.row)
        self.videosCollectionView.reloadData()
    }

    func deleteCurrentFeedback() {
        let visibleRect = CGRect(origin: feedbacksCollectionVIew.contentOffset, size: feedbacksCollectionVIew.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let visibleIndexPath = feedbacksCollectionVIew.indexPathForItem(at: visiblePoint) else { return }
        self.allFeedbacks.remove(at: visibleIndexPath.row)
        self.feedbacksCollectionVIew.reloadData()
    }

    func showDeleteVideoAlert() {
        let sheet = UIAlertController(title: "Warning", message: "Delete this video?", preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Yes, delete", style: .destructive, handler: { _ in
            self.deleteCurrentVideo()
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(sheet, animated: true, completion: nil)
    }

    func showDeleteFeedbackAlert() {
        let sheet = UIAlertController(title: "Warning", message: "Delete this feedback?", preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Yes, delete", style: .destructive, handler: { _ in
            self.deleteCurrentFeedback()
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(sheet, animated: true, completion: nil)
    }

    func insertNewVideo(videoId: String) {
        self.videosLongTapRecognizer.isEnabled = true
        self.allVideos.append(videoId)
        self.videosCollectionView.reloadData()
    }

    func insertNewFeedback(videoId: String) {
        self.feedbacksLongTapRecognizer.isEnabled = true
        self.allFeedbacks.append(videoId)
        self.feedbacksCollectionVIew.reloadData()
    }

    func loadVideoLinks(from array: [String], doForEachLink: ((String) -> Void)) {
        array.forEach { link in
            let videoId: String?

            if link.contains("="), let lastAfterEqual = link.components(separatedBy: "=").last {
                videoId = lastAfterEqual
            } else if let lastAfterSlash = link.components(separatedBy: "/").last {
                videoId = lastAfterSlash
            } else {
                videoId = nil
            }

            if let id = videoId {
                doForEachLink(id)
            }
        }
    }
}

extension MyProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let data = getDataArray(for: collectionView)
        if GlobalManager.myUser == artist {
            return data.count + 1
        } else {
            return data.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == videosCollectionView || collectionView == feedbacksCollectionVIew {
            let data = getDataArray(for: collectionView) as! [VideoId]

            if collectionView == videosCollectionView {
                videosCollectionView.layer.borderWidth = allVideos.isEmpty ? 1 : 0
            }

            if indexPath.row == data.count {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "AddVideoCell", for: indexPath)
            } else {
                let videoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCell
                let videoId = data[indexPath.row]
                videoCell.playerView.load(withVideoId: videoId)
                return videoCell
            }
        } else {
            let data = getDataArray(for: collectionView) as! [UIImage]
            photosCollectionView.layer.borderWidth = allPhotos.isEmpty ? 1 : 0

            if indexPath.row == data.count {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "AddVideoCell", for: indexPath)
            } else {
                let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
                
                let image = data[indexPath.row]
                photoCell.photoImageView.image = image
                return photoCell
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == photosCollectionView {
            if indexPath.row < allPhotos.count {
                slideShow.circular = false
                slideShow.setImageInputs(allPhotos.map { ImageSource(image: $0) })
                slideShow.setCurrentPage(indexPath.row, animated: false)
                slideShow.presentFullScreenController(from: self)
            } else {
                imagePickerForUserPhoto = false
                openGalery()
            }
        } else if collectionView == videosCollectionView {
            if indexPath.row < allVideos.count, let cell = videosCollectionView.cellForItem(at: indexPath) as? VideoCell {
                if cell.playerView.playerState() == .playing {
                    cell.playerView.pauseVideo()
                } else {
                    cell.playerView.playVideo()
                }
            } else {
                openAddNewVideo()
            }
        } else if collectionView == feedbacksCollectionVIew {
            if indexPath.row < allVideos.count, let cell = feedbacksCollectionVIew.cellForItem(at: indexPath) as? VideoCell {
                if cell.playerView.playerState() == .playing {
                    cell.playerView.pauseVideo()
                } else {
                    cell.playerView.playVideo()
                }
            } else {
                openAddNewFeedback()
            }
        }
    }

    func openAddNewVideo() {
        let addVideoVC = self.storyboard?.instantiateViewController(withIdentifier: "AddVideoVC") as! SetUserVideoViewController

        addVideoVC.finishBlock = { videoString in
            if let videoId = videoString {
                self.insertNewVideo(videoId: videoId)
            }
        }

        let navC = UINavigationController(rootViewController: addVideoVC)
        present(navC, animated: true, completion: nil)
    }

    func openAddNewFeedback() {
        let addVideoVC = self.storyboard?.instantiateViewController(withIdentifier: "AddVideoVC") as! SetUserVideoViewController

        addVideoVC.finishBlock = { videoString in
            if let videoId = videoString {
                self.insertNewFeedback(videoId: videoId)
            }
        }
        let navC = UINavigationController(rootViewController: addVideoVC)
        present(navC, animated: true, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 37, height: 200)
    }

    func getDataArray(for collectionView: UICollectionView) -> [Any] {
        if collectionView == videosCollectionView {
            return allVideos
        } else if collectionView == feedbacksCollectionVIew {
            return allFeedbacks
        } else {
            return allPhotos
        }
    }
}
