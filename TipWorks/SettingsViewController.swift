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
    
    
    
    
    var languageIndex = 0
    var maxNumberToSplit = 10


    
    let tableViewCellIdentifiers = ["tipPercTableViewCell", "maxNumberToSplitTableViewCell", "languageTableViewCell"]
    let languageOptions = ["English", "español", "中文", "日本語"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        languagePickerView.isHidden = true
        tapRecognizer.isEnabled = false
    }
    
    // MARK: picker view delegate functions
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languageOptions.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languageOptions[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        languageIndex = row
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
                print("placeholder")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = tableViewCellIdentifiers[indexPath.row]
        
        let reuseCell = tableView.dequeueReusableCell(withIdentifier: identifier)!
        
        
        switch identifier {
            case "tipPercTableViewCell":
                let cell = reuseCell as! tipPercTableViewCell
                cell.currentSelectionLabel.text = "placeholder"
            
            case "maxNumberToSplitTableViewCell":
                let cell = reuseCell as! maxNumberToSplitTableViewCell
                
                cell.syncFromStorage()
            
            case "languageTableViewCell":
                let cell = reuseCell as! languageTableViewCell
                cell.currentSelectionLabel.text = languageOptions[languageIndex]

            default:
                print("placeholder")

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
        tableView.reloadData()
    }

    
    

    
    
}


