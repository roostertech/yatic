//
//  ViewController.swift
//  YATIC
//
//  Created by Phuong Nguyen on 8/8/17.
//  Copyright © 2017 Phuong Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var inputPanel: UIView!
    @IBOutlet weak var outputPanel: UIView!
    
    @IBOutlet var background: UIView!
    @IBOutlet weak var tipPercentControl: UISegmentedControl!
    @IBOutlet weak var splitControl: UISegmentedControl!
    @IBOutlet weak var billField: UITextField!
    
    @IBOutlet weak var settingButton: UIBarButtonItem!
    
    var formatter = NumberFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.groupingSeparator = Locale.current.groupingSeparator
        formatter.currencyCode = Locale.current.currencyCode
        formatter.maximumFractionDigits = 2

        
        // restore previous tip amount
        tipPercentControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: SettingsController.Settings.tip_index)
        
        restoreBillAmount();
        billField.becomeFirstResponder()
        splitControl.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.white], for:.selected)
    }
    
    func restoreBillAmount() {
        // Restore bill amount if value is less than 10 mins old
        let date = Date()
        let billDate = (UserDefaults.standard.object(forKey: SettingsController.Settings.bill_date) ?? Date(timeIntervalSince1970: TimeInterval(0))) as! Date
        let billAmount = UserDefaults.standard.double(forKey: SettingsController.Settings.bill_amount)
        if billAmount == 0 {
            print("No previous value")
            hidePanel()
            return;
        }
        
        let expireDate = Date(timeInterval: TimeInterval(600), since: billDate)
        if (date.compare(expireDate) == ComparisonResult.orderedAscending) {
            print("Restoring amount ", billAmount)
            billField.text = billAmount.description;
            calculateTip(NSNull.self)
        } else {
            hidePanel()
            print("Stale bill amount")
        }
    }
    
    func hidePanel() {
        UIView.animate(withDuration: 0.4, animations: {
            self.outputPanel.alpha = 0
        })
    }
    func showPanel() {
        UIView.animate(withDuration: 0.4, animations: {
            self.outputPanel.alpha = 1
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func calculateTip(_ sender: Any) {
        let tipPercent = [0.12, 0.15, 0.18, 0.20]
        let bill = Double(billField.text!) ?? 0
        let tip = bill * tipPercent[ tipPercentControl.selectedSegmentIndex ]
        let total = tip + bill
        let splitIndex = splitControl.selectedSegmentIndex
        

        if (bill == 0) {
            UserDefaults.standard.set(bill, forKey: SettingsController.Settings.bill_amount)
            UserDefaults.standard.synchronize()
            hidePanel()
            return
        }
        
        showPanel()
        
        if (splitIndex == 0) {
            tipLabel.text = formatter.currencySymbol + formatter.string(from: NSNumber(value: tip))!
            totalLabel.text = formatter.currencySymbol + formatter.string(from: NSNumber(value: total))!
        } else {
            let splitTip = tip / (Double)(splitIndex + 1)
            let splitTotal = total / (Double)(splitIndex + 1)
            
            tipLabel.text = formatter.currencySymbol + formatter.string(from: NSNumber(value: splitTip))!
            totalLabel.text = formatter.currencySymbol + formatter.string(from: NSNumber(value: splitTotal))!
        }
        
        let date = Date()
        UserDefaults.standard.set(tipPercentControl.selectedSegmentIndex, forKey: SettingsController.Settings.tip_index)
        UserDefaults.standard.set(date, forKey: SettingsController.Settings.bill_date)
        UserDefaults.standard.set(bill, forKey: SettingsController.Settings.bill_amount)
        UserDefaults.standard.synchronize()
        
    }
    
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyStoredTheme()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func applyStoredTheme() {
        let theme = UserDefaults.standard.integer(forKey: SettingsController.Settings.theme)
      
        print("Switching Tip Scene theme to \(SettingsController.Settings.theme_names[theme])")
        switch theme {
        case SettingsController.Settings.theme_dark_val:
            tipPercentControl.tintColor = UIColor.white
            splitControl.tintColor = UIColor.white
            inputPanel.backgroundColor = UIColor(displayP3Red: 0.50378066957366774, green: 0.67718820381177824, blue: 1, alpha: 1)
            outputPanel.backgroundColor = UIColor.gray
        case SettingsController.Settings.theme_light_val:
            tipPercentControl.tintColor = UIColor.blue
            splitControl.tintColor = UIColor.blue
            inputPanel.backgroundColor = UIColor(displayP3Red: 0.6710506052712617, green: 0.93995184558734635, blue: 1, alpha: 1)
            outputPanel.backgroundColor = UIColor.white
        default:
            inputPanel.backgroundColor = UIColor(displayP3Red: 0.6710506052712617, green: 0.93995184558734635, blue: 1, alpha: 1)
        }
    }
}


