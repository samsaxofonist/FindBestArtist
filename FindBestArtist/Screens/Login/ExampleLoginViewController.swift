//
//  ExampleLoginViewController.swift
//  FindBestArtist
//
//  Created by Samus Dimitriy on 12.10.2018.
//  Copyright © 2018 Samus Dimitrij. All rights reserved.
//

import UIKit
@IBDesignable

class ExampleLoginViewController: UIViewController {

    @IBOutlet weak var LogInButtonOutlet: UIButton!
    @IBOutlet weak var SingUpFreeButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
