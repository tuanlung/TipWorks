//
//  SettingsViewController.swift
//  TipWorks
//
//  Created by Tuan-Lung Wang on 8/10/17.
//  Copyright © 2017 Tuan-Lung Wang. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    

    @IBOutlet weak var languagePickerView: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!

    // constructor takes care of the default settings. See SettingsData.swift
    var settings = SettingsData()

    
    let tableViewCellIdentifiers = ["tipPercTableViewCell", "maxNumberToSplitTableViewCell", "languageTableViewCell"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        languagePickerView.isHidden = true
        tapRecognizer.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let settings = Storage.load(key: "settings") as? SettingsData {
            self.settings = settings
        }
        
        translateUserInterface()
        
        tableView.reloadData()
    }
    
    // MARK: picker view delegate functions
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Translator.languageOptions.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Translator.languageOptions[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        settings.languageOption = row
    }
    
    // MARK: table view delegate functions
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let identifier = tableViewCellIdentifiers[indexPath.row]
            
        switch identifier {
            case "tipPercTableViewCell":
                performSegue(withIdentifier: "toTipPercentageSegue", sender: self)
            case "languageTableViewCell":
                languagePickerView.isHidden = false
                tapRecognizer.isEnabled = true
            default:
                print("Selected " + identifier + ", do nothing.")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = tableViewCellIdentifiers[indexPath.row]
        let reuseCell = tableView.dequeueReusableCell(withIdentifier: identifier)!
        
        switch identifier {
            case "tipPercTableViewCell":
                let cell = reuseCell as! tipPercTableViewCell
                
                let tipOptions = settings.tipOptions
                var optStr = ""
                for (index, opt) in tipOptions.enumerated() {
                    optStr.append(opt.description + "%")
                    if index != tipOptions.count - 1 {
                        optStr.append("/")
                    }
                }
                cell.titleLabel.text = Translator.translate(settings: settings, word: "Tip Percentage")
                cell.currentSelectionLabel.text = optStr
            
            case "maxNumberToSplitTableViewCell":
                let cell = reuseCell as! maxNumberToSplitTableViewCell
                let maxNum = settings.maxNumToSplit
                cell.stepper.value = Double(maxNum)
                cell.currentValueLabel.text = maxNum.description
                cell.titleLabel.text = Translator.translate(settings: settings, word: "Max Number to Split")
            
            case "languageTableViewCell":
                let cell = reuseCell as! languageTableViewCell
                cell.currentSelectionLabel.text = Translator.languageOptions[settings.languageOption]
                cell.titleLabel.text = Translator.translate(settings: settings, word: "Language")

            default:
                print("Should never reach here")

        }
        
        return reuseCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewCellIdentifiers.count
    }
    
    
    // MARK: IBActions
    @IBAction func tappedOnTableView(_ sender: Any) {
        languagePickerView.isHidden = true
        tapRecognizer.isEnabled = false
        Storage.save(key: "settings", value: settings)
        tableView.reloadData()
    }

    
    @IBAction func stepperValueDidChange(_ sender: Any) {
        let stepper = sender as! UIStepper
        settings.maxNumToSplit = Int(stepper.value)
        Storage.save(key: "settings", value: settings)
        tableView.reloadData()
    }
    
    // MARK: translation
    func translateUserInterface() {
        navigationItem.title = Translator.translate(settings: settings, word: "Settings")
    }
}


