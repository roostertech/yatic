//
//  SettingsControllerViewController.swift
//  YATIC
//
//  Created by Phuong Nguyen on 8/15/17.
//  Copyright © 2017 Phuong Nguyen. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {

    struct Settings {
        static let theme = "settings_theme"
        static let tip_index = "tip_index"
        static let bill_date = "bill_date"
        static let bill_amount = "bill_amount"
        
        static let theme_light_val = 0
        static let theme_dark_val = 1
        static let theme_names = ["light", "dark"]
    }
    
    @IBOutlet weak var themeControl: UISegmentedControl!
    @IBOutlet var background: UIView!
    
    func applyStoredTheme() {
        let themeIndex = UserDefaults.standard.integer(forKey: Settings.theme)

        print("Switching theme to \(Settings.theme_names[themeIndex])")
        switch themeIndex {
        case Settings.theme_dark_val:
            background.backgroundColor = UIColor(displayP3Red: 0.50378066957366774, green: 0.67718820381177824, blue: 1, alpha: 1)
        case Settings.theme_light_val:
            background.backgroundColor = UIColor(displayP3Red: 0.6710506052712617, green: 0.93995184558734635, blue: 1, alpha: 1)
        default:
            background.backgroundColor = UIColor(displayP3Red: 0.6710506052712617, green: 0.93995184558734635, blue: 1, alpha: 1)
        }
    }
    
    @IBAction func onThemeChanged(_ sender: Any) {
        UserDefaults.standard.set(themeControl.selectedSegmentIndex, forKey: Settings.theme)
        UserDefaults.standard.synchronize()
        applyStoredTheme();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let theme = UserDefaults.standard.integer(forKey: Settings.theme)
        applyStoredTheme();
        themeControl.selectedSegmentIndex = theme
    }
}
