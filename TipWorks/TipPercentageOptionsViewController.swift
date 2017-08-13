//
//  tipPercentageOptionsViewController.swift
//  TipWorks
//
//  Created by Tuan-Lung Wang on 8/11/17.
//  Copyright © 2017 Tuan-Lung Wang. All rights reserved.
//

import UIKit

class TipPercentageOptionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // constructor takes care of the default settings. See SettingsData.swift
    var settings = SettingsData()
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let settings = Storage.load(key: "settings") as? SettingsData {
            self.settings = settings
        }
    }
    
    // MARK: table view delegate functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.tipOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tipPercOptionTableViewCell") as! TipPercOptionTableViewCell
        
        let row = indexPath.row
        
        cell.titleLabel.text = "Option \(row+1)"
        cell.valueTextField.text = settings.tipOptions[row].description
        cell.valueTextField.tag = row
        cell.defaultSwitch.tag = row
        
        if row == settings.defaultTipOption {
            cell.defaultSwitch.isOn = true
        } else {
            cell.defaultSwitch.isOn = false
        }
        
        return cell
    }
    
    // MARK: text field delegate functions
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let numStr = textField.text, let num = Int(numStr) {
            settings.tipOptions[textField.tag] = num
        } else {
            // no number, set textfield back to original value
            textField.text = settings.tipOptions[textField.tag].description
        }
    }
    
    // MARK: IBActions
    @IBAction func cancel(_ sender: Any) {
        view.endEditing(true)
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        view.endEditing(true)
        
        Storage.save(key: "settings", value: settings)
        
        navigationController?.popViewController(animated: true)
    }
    

    @IBAction func userDidTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func defaultSwitchValueDidChange(_ sender: Any) {
        let defaultSwitch = sender as! UISwitch
        settings.defaultTipOption = defaultSwitch.tag
        tableView.reloadData()
    }
}

class TipPercOptionTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var defaultSwitch: UISwitch!
    @IBOutlet weak var valueTextField: UITextField!

}
