//
//  HistoryViewController.swift
//  TipWorks
//
//  Created by Tuan-Lung Wang on 8/13/17.
//  Copyright © 2017 Tuan-Lung Wang. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var dateTitleLabel: UILabel!
    @IBOutlet weak var paymentTitleLabel: UILabel!
    
    var history = HistoryData()
    var settings = SettingsData()
    
    // MARK: Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let history = Storage.load(key: "history") as? HistoryData {
            self.history = history
        }
        
        if let settings = Storage.load(key: "settings") as? SettingsData {
            self.settings = settings
        }
        
        translateUserInterface()
    }
    
    // MARK: table view delegate functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyTableViewCell") as! HistoryTableViewCell
        let record = history.records[indexPath.row]
        
        let tip = Translator.translate(settings: settings, word: "Tip")
        
        cell.dateLabel.text = record.date
        cell.paymentLabel.text = String(format: "$%10.2f (%d%% ", record.total, record.percentage) + tip
        
        return cell
    }
    
    // translation
    func translateUserInterface() {
        dateTitleLabel.text = Translator.translate(settings: settings, word: "Date")
        paymentTitleLabel.text = Translator.translate(settings: settings, word: "Payment")
    }
    
}
