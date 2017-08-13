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
    @IBOutlet weak var tableView: UITableView!
    
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
        
        // latest should be shown at top
        let numOfRecords = history.records.count
        let record = history.records[numOfRecords - 1 - indexPath.row]
        
        let tip = Translator.translate(settings: settings, word: "Tip")
        
        cell.dateLabel.text = record.date
        cell.paymentLabel.text = String(format: "$%.2f (%d%% ", record.total, record.percentage) + tip + ")"
        
        return cell
    }
    
    // MARK: translation
    func translateUserInterface() {
        navigationItem.title = Translator.translate(settings: settings, word: "History")
        navigationItem.rightBarButtonItem?.title = Translator.translate(settings: settings, word: "Clear")
        dateTitleLabel.text = Translator.translate(settings: settings, word: "Date")
        paymentTitleLabel.text = Translator.translate(settings: settings, word: "Payment")
    }
    
    // MARK: IBActions
    @IBAction func tapOnClearButton(_ sender: Any) {
        history.records.removeAll(keepingCapacity: false)
        tableView.reloadData()
        Storage.save(key: "history", value: history)
    }
}
