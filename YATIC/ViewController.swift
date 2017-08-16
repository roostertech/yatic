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
    
    @IBOutlet var background: UIView!
    @IBOutlet weak var tipPercentControl: UISegmentedControl!
    @IBOutlet weak var splitControl: UISegmentedControl!
    @IBOutlet weak var billField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // restore previous tip amount
        tipPercentControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: SettingsController.Settings.tip_index)
        
        restoreBillAmount();
        billField.becomeFirstResponder()
    }

    func restoreBillAmount() {
        // Restore bill amount if value is less than 5mins old
        let date = Date()
        let billDate = (UserDefaults.standard.object(forKey: SettingsController.Settings.bill_date) ?? Date(timeIntervalSince1970: TimeInterval(0))) as! Date
        let billAmount = UserDefaults.standard.double(forKey: SettingsController.Settings.bill_amount)
        if billAmount == 0 {
            print("No previous value")
            return;
        }
        let expireDate = Date(timeInterval: TimeInterval(300), since: billDate)
        if (date.compare(expireDate) == ComparisonResult.orderedAscending) {
            print("Restoring amount ", billAmount)
            billField.text = billAmount.description;
            calculateTip(NSNull.self)
        } else {
            print("Stale bill amount")
        }
        
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
        let currencySymbol = Locale.current.currencySymbol ?? "$"
        let splitIndex = splitControl.selectedSegmentIndex

        
        if (splitIndex == 0) {
            tipLabel.text = String(format: "%@ %3.2f", currencySymbol, tip)
            totalLabel.text = String(format: "%@ %3.2f", currencySymbol, total)
        } else {
            let splitTip = tip / (Double)(splitIndex + 1)
            let splitTotal = total / (Double)(splitIndex + 1)

            tipLabel.text = String(format: "%@ %3.2f / %3.2f", currencySymbol, splitTip, tip)
            totalLabel.text = String(format: "%@ %3.2f / %3.2f", currencySymbol, splitTotal, total)

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
        SettingsController.applyStoredTheme(background: background)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}


