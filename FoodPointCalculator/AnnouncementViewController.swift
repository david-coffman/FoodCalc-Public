//
//  AnnouncementViewController.swift
//  FoodPointCalculator
//
//  Created by David Coffman on 10/17/19.
//  Copyright © 2019 David Coffman. All rights reserved.
//

import UIKit

class AnnouncementViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bodyTextLabel: UILabel!
    @IBOutlet var fullscreenImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let announcement = globalAnnouncement {
            if announcement.isText {
                fullscreenImage.isHidden = true
                titleLabel.text = announcement.title
                bodyTextLabel.text = announcement.bodyText
                globalUserData.lastDisplayedAnnouncement = globalAnnouncement.date
                globalUserData.save()
            }
            else {
                fullscreenImage.image = UIImage(data: announcementImageData)
                globalUserData.lastDisplayedAnnouncement = globalAnnouncement.date
                globalUserData.save()
            }
        }
        else {
            dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func dismissButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
