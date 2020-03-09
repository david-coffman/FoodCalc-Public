//
//  ViewController.swift
//  FoodPointCalculator
//
//  Created by David Coffman on 10/10/19.
//  Copyright © 2019 David Coffman. All rights reserved.
//

import UIKit

var displayVC: ViewController?
var globalAnnouncement: Announcement!
var announcementImageData: Data!

class ViewController: UIViewController {

    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var daysRemainingLabel: UILabel!
    @IBOutlet var endOfDayBalance: UILabel!
    @IBOutlet var remainingPerDay: UILabel!
    @IBOutlet var swipesRemaining: UILabel!
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter
    }()
    
    let dayFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        checkAnnouncement()
        displayVC = self
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateLabels()
    }
    
    func updateLabels() {
        dayLabel.text = "\(dayFormatter.string(from: Date()))"
        dateLabel.text = "\(dateFormatter.string(from: Date()))"
        endOfDayBalance.text = "$\((globalUserData.calcEODBalance()*100).rounded()/100)"
        remainingPerDay.text = "$\((globalUserData.calcPointsPerDay()*100).rounded()/100)"
        swipesRemaining.text = "\((globalUserData.calcSwipesPerWeek()*100).rounded()/100)"
        daysRemainingLabel.text = "\(Int(globalUserData.endDate.timeIntervalSince(Date())/86400)+1) days remaining"
    }
    
    func checkAnnouncement() {
        let latestDataLocation = "https://www.dropbox.com/s/wtx1fzweeg4m5nj/current_announcement.json?dl=1"
        let lastestDataURL = URL(string: latestDataLocation)!
        let dataTask = URLSession.shared.dataTask(with: lastestDataURL) {(data, response, error) in
            if let data = data {
                let announcement = try! JSONDecoder().decode(Announcement.self, from: data)
                globalAnnouncement = announcement
                if globalUserData.lastDisplayedAnnouncement >= announcement.date {return}
                if !announcement.isText {
                    let imageDataTask = URLSession.shared.dataTask(with: announcement.imageURL!) {
                        (data, response, error) in
                        if let data = data {
                            announcementImageData = data
                        }
                    }
                    imageDataTask.resume()
                }
                else {
                    self.popAnnouncementWindow(announcement: announcement)
                }
            }
        }
        dataTask.resume()
    }
    
    func popAnnouncementWindow(announcement: Announcement) {
        DispatchQueue.main.async {
            if globalAnnouncement.date > globalUserData.lastDisplayedAnnouncement {
                self.performSegue(withIdentifier: "popAnnouncement", sender: self)
            }
        }
    }
    
}

