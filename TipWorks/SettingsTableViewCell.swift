//
//  SettingsTableViewCell.swift
//  TipWorks
//
//  Created by Tuan-Lung Wang on 8/11/17.
//  Copyright © 2017 Tuan-Lung Wang. All rights reserved.
//

import UIKit

class tipPercTableViewCell: UITableViewCell {
    @IBOutlet weak var currentSelectionLabel: UILabel!
}

class maxNumberToSplitTableViewCell: UITableViewCell {
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var currentValueLabel: UILabel!
    
    func syncFromStorage() {
        stepper.value = 2
        updateLabel()
    }
    
    func syncToStorage() {
        
    }
    
    func updateLabel() {
        currentValueLabel.text = Int(stepper.value).description
    }
    
    @IBAction func valueDidChange(_ sender: Any) {
        updateLabel()
        syncToStorage()
    }
}

class languageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var currentSelectionLabel: UILabel!
}
