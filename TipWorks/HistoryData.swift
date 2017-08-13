//
//  HistoryData.swift
//  TipWorks
//
//  Created by Tuan-Lung Wang on 8/12/17.
//  Copyright © 2017 Tuan-Lung Wang. All rights reserved.
//

import Foundation

class HistoryData: NSObject, NSCoding {
    var records: [PaymentData] = []
    
    override init() {}
    
    required init(coder aDecoder: NSCoder) {
        if let records = aDecoder.decodeObject(forKey: "records") as? [PaymentData] {
            self.records = records
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(records, forKey: "records")
    }
    
    override var description: String {
        get {
            var s = ""
            for r in records {
                s.append(r.description + "\n")
            }
            return s
        }
    }
}
