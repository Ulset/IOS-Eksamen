//
//  PersonViewController.swift
//  eksamen
//
//  Created by Sander Ulset on 25/10/2021.
//

import UIKit

class PersonViewController: UIViewController {
    var person: Person?
    @IBOutlet weak var profilePicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global().async {
            if let pictureUrl = self.person?.picture.large {
                ApiHandler.getImageFromURL(url: pictureUrl, finished: {image in
                    self.profilePicture.image = image
                })
            }
        }
    }
}
