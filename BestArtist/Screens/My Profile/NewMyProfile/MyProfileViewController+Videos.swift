//
//  MyProfileViewController+Videos.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 22.12.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit

extension MyProfileViewController {
    @IBAction func longTapOnVideos(_ sender: Any) {
        showDeleteVideoAlert()
    }

    @IBAction func longTapOnFeedbacks(_ sender: Any) {
        showDeleteFeedbackAlert()
    }

    @IBAction func tapOnAddVideo(_ sender: Any) {
        let addVideoNav = self.storyboard?.instantiateViewController(withIdentifier: "AddVideoNavigation") as! UINavigationController
        let addVideoVC = addVideoNav.viewControllers.first as! SetUserVideoViewController

        addVideoVC.finishBlock = { videoString in
            if let videoId = videoString {
                self.insertNewVideo(videoId: videoId)
            }
        }
        present(addVideoNav, animated: true, completion: nil)
    }

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
        self.allVideos.append(videoId)
        self.videosCollectionView.reloadData()
    }

    func insertNewFeedback(videoId: String) {
        self.allFeedbacks.append(videoId)
        self.feedbacksCollectionVIew.reloadData()
    }

    @IBAction func tapOnAddFeedback(_ sender: Any) {
        let addVideoNav = self.storyboard?.instantiateViewController(withIdentifier: "AddVideoNavigation") as! UINavigationController
        let addVideoVC = addVideoNav.viewControllers.first as! SetUserVideoViewController

        addVideoVC.finishBlock = { videoString in
            if let videoId = videoString {
                self.allFeedbacks.append(videoId)
                self.feedbacksCollectionVIew.reloadData()
            }
        }
        present(addVideoNav, animated: true, completion: nil)
    }

}

extension MyProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let data = getDataArray(for: collectionView)
        return data.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let data = getDataArray(for: collectionView)

        if indexPath.row == data.count {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "AddVideoCell", for: indexPath)
        } else {
            let videoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCell


            let videoId = data[indexPath.row]

            videoCell.playerView.load(withVideoId: videoId)
            return videoCell
        }
    }

    func getDataArray(for collectionView: UICollectionView) -> [VideoId] {
        if collectionView == videosCollectionView {
            return allVideos
        } else {
            return allFeedbacks
        }
    }
}
