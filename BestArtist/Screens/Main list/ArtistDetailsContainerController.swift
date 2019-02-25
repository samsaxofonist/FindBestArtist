//
//  ArtistDetailsContainerController.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 25.02.19.
//  Copyright © 2019 kievkao. All rights reserved.
//

import UIKit

class ArtistDetailsContainerController: BaseViewController {
    var selectedArtist: Artist!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailsViewController = segue.destination as? ArtistDetailsViewController
        detailsViewController?.selectedArtist = selectedArtist
    }

}
