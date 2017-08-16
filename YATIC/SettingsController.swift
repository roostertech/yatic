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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    static func applyStoredTheme(background : UIView) {
        let theme = UserDefaults.standard.integer(forKey: Settings.theme)
        applyTheme(themeIndex: theme, background: background)
    }
    
    static func applyTheme(themeIndex :Int, background : UIView) {
        print("Switching theme to \(Settings.theme_names[themeIndex])")
        switch themeIndex {
        case Settings.theme_dark_val:
            background.backgroundColor = UIColor.darkGray
        case Settings.theme_light_val:
            background.backgroundColor = UIColor.white
        default:
            background.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func onThemeChanged(_ sender: Any) {
        UserDefaults.standard.set(themeControl.selectedSegmentIndex, forKey: Settings.theme)
        UserDefaults.standard.synchronize()
        
        SettingsController.applyTheme(themeIndex: themeControl.selectedSegmentIndex, background: background)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let theme = UserDefaults.standard.integer(forKey: Settings.theme)
        SettingsController.applyTheme(themeIndex: theme, background: background)
        themeControl.selectedSegmentIndex = theme
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}
