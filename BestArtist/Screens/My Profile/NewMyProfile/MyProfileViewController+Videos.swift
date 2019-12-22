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
        showDeletePhotoAlert()
    }

    @IBAction func longTapOnFeedbacks(_ sender: Any) {
        showDeletePhotoAlert()
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
