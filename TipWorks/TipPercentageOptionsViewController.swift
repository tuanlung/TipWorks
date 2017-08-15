//
//  tipPercentageOptionsViewController.swift
//  TipWorks
//
//  Created by Tuan-Lung Wang on 8/11/17.
//  Copyright © 2017 Tuan-Lung Wang. All rights reserved.
//

import UIKit

class TipPercentageOptionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    // MARK: IBOutlets
    @IBOutlet weak var defaultLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: Data Members
    // constructor takes care of the default settings. See SettingsData.swift
    var settings = SettingsData()
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let settings = Storage.load(key: "settings") as? SettingsData {
            self.settings = settings
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        translateUserInterface()
    }
    
    
    // MARK: Table View Delegate Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.tipOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tipPercOptionTableViewCell") as! TipPercOptionTableViewCell
        
        let row = indexPath.row
        let option = Translator.translate(settings: settings, word: "Option")
        
        cell.titleLabel.text = option + " \(row+1)"
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
    
    
    // MARK: Text Field Delegate Functions
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
    
    
    // MARK: Translation
    func translateUserInterface() {
        navigationItem.leftBarButtonItem?.title = Translator.translate(settings: settings, word: "Cancel")
        navigationItem.title = Translator.translate(settings: settings, word: "Tip Options Setting")
        navigationItem.rightBarButtonItem?.title = Translator.translate(settings: settings, word: "Save")
        defaultLabel.text = Translator.translate(settings: settings, word: "Default")
    }
}

class TipPercOptionTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var defaultSwitch: UISwitch!
    @IBOutlet weak var valueTextField: UITextField!

}
