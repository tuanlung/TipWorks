//
//  tipPercentageOptionsViewController.swift
//  TipWorks
//
//  Created by Tuan-Lung Wang on 8/11/17.
//  Copyright © 2017 Tuan-Lung Wang. All rights reserved.
//

import UIKit

class TipPercentageOptionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    var tipOptionValues: [Int] = [18, 20, 25]
    var defaultOption = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tipOptionValues = Storage.load(key: "tipOptionValues") as? [Int] {
            self.tipOptionValues = tipOptionValues
        }
        
        if let defaultOption = Storage.load(key: "defaultOption") as? Int {
            self.defaultOption = defaultOption
        }
    }
    
    // MARK: table view delegate functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tipOptionValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tipPercOptionTableViewCell") as! TipPercOptionTableViewCell
        
        let row = indexPath.row
        
        cell.titleLabel.text = "Option \(row+1)"
        cell.valueTextField.text = tipOptionValues[row].description
        cell.valueTextField.tag = row
        cell.defaultSwitch.tag = row
        
        if row == defaultOption {
            cell.defaultSwitch.isOn = true
        } else {
            cell.defaultSwitch.isOn = false
        }
        
        return cell
    }
    
    // MARK: text field delegate functions
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let numStr = textField.text {
            tipOptionValues[textField.tag] = Int(numStr)!
        } else {
            // no number, set textfield back to original value
            textField.text = tipOptionValues[textField.tag].description
        }
    }
    
    // MARK: IBActions
    @IBAction func cancel(_ sender: Any) {
        view.endEditing(true)
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        view.endEditing(true)
        
        Storage.save(key: "tipOptionValues", value: tipOptionValues)
        Storage.save(key: "defaultOption", value: defaultOption)
        
        navigationController?.popViewController(animated: true)
    }
    

    @IBAction func userDidTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func defaultSwitchValueDidChange(_ sender: Any) {
        let defaultSwitch = sender as! UISwitch
        defaultOption = defaultSwitch.tag
        tableView.reloadData()
    }
}

class TipPercOptionTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var defaultSwitch: UISwitch!
    @IBOutlet weak var valueTextField: UITextField!

}
