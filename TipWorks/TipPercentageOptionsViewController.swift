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
    var defaultOption = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tipOptionValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tipPercOptionTableViewCell") as! TipPercOptionTableViewCell
        
        let row = indexPath.row
        
        cell.titleLabel.text = "Option \(row+1)"
        cell.valueTextField.text = tipOptionValues[row].description + "%"
        if row == defaultOption {
            cell.defaultSwitch.isOn = true
        } else {
            cell.defaultSwitch.isOn = false
        }
        
        return cell
    }
    
    
    // MARK: IBActions
    @IBAction func cancel(_ sender: Any) {
        //navigationController?.popViewController(animated: true)
        Storage.save(key: "tlwang", value: PaymentData())
    }
    
    @IBAction func save(_ sender: Any) {
        //navigationController?.popViewController(animated: true)
        var num = Storage.load(key: "tlwang") as! PaymentData
        //tipOptionValues = [num.a, num.b, num.c]
        //tableView.reloadData()
        print(num.description)
        
        
        num.date = num.date + "A"
        num.total = num.total + 1.0
        num.percentage = num.percentage + 1
        
        Storage.save(key: "tlwang", value: num)
    }
    
}

class TipPercOptionTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var defaultSwitch: UISwitch!
    @IBOutlet weak var valueTextField: UITextField!

}
