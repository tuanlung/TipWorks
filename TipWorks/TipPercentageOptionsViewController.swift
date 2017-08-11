//
//  tipPercentageOptionsViewController.swift
//  TipWorks
//
//  Created by Tuan-Lung Wang on 8/11/17.
//  Copyright © 2017 Tuan-Lung Wang. All rights reserved.
//

import UIKit

class TipPercentageOptionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tipOptionValues: [Int] = [18, 20, 25]
    var defaultOoption = 0
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tipOptionValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tipPercOptionTableViewCell") as! TipPercOptionTableViewCell
        
        let row = indexPath.row
        
        cell.titleLabel.text = "Option \(row+1)"
        cell.valueTextField.text = tipOptionValues[row].description + "%"
        if row == defaultOoption {
            cell.defaultSwitch.isOn = true
        } else {
            cell.defaultSwitch.isOn = false
        }
        
        return cell
    }
    
    
    // MARK: IBActions
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

class TipPercOptionTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var defaultSwitch: UISwitch!
    @IBOutlet weak var valueTextField: UITextField!

}
