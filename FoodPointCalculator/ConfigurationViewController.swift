//
//  ConfigurationViewController.swift
//  FoodPointCalculator
//
//  Created by David Coffman on 10/10/19.
//  Copyright © 2019 David Coffman. All rights reserved.
//

import UIKit

class ConfigurationViewController: UIViewController {

    @IBOutlet var foodPointTextBox: UITextField!
    @IBOutlet var mealSwipeTextBox: UITextField!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var fallSwitch: UISwitch!
    @IBOutlet var thanksgivingSwitch: UISwitch!
    @IBOutlet var springSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodPointTextBox.text = "\(globalUserData.pointBalance)"
        mealSwipeTextBox.text = "\(globalUserData.swipeBalance)"
        fallSwitch.isOn = globalUserData.ignoreFallBreak
        thanksgivingSwitch.isOn = globalUserData.ignoreThanksgivingBreak
        springSwitch.isOn = globalUserData.ignoreSpringBreak
    }
    
    @IBAction func toggleFall(_ sender: Any) {
        globalUserData.ignoreFallBreak = fallSwitch.isOn
        globalUserData.save()
        if let displayVC = displayVC {
            displayVC.updateLabels()
        }
    }
    
    @IBAction func toggleThanksgiving(_ sender: Any) {
        globalUserData.ignoreThanksgivingBreak = thanksgivingSwitch.isOn
        globalUserData.save()
        if let displayVC = displayVC {
            displayVC.updateLabels()
        }
    }
    
    @IBAction func toggleSpring(_ sender: Any) {
        globalUserData.ignoreSpringBreak = springSwitch.isOn
        globalUserData.save()
        if let displayVC = displayVC {
            displayVC.updateLabels()
        }
    }
    
    @IBAction func balanceChange(_ sender: Any) {
        guard let swipes = Int(mealSwipeTextBox.text!), let points = Double(foodPointTextBox.text!) else {return}
        globalUserData.startDate = Date()
        globalUserData.swipeBalance = swipes
        globalUserData.pointBalance = points
        globalUserData.save()
        
        if let displayVC = displayVC {
            displayVC.updateLabels()
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.backgroundColor = .systemGreen
        }, completion: {(Bool) -> Void in
            self.dismiss(animated: true, completion: nil)
        })
    }
    @IBAction func dismissButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
