//
//  PaymentData.swift
//  TipWorks
//
//  Created by Tuan-Lung Wang on 8/12/17.
//  Copyright © 2017 Tuan-Lung Wang. All rights reserved.
//

import Foundation

class PaymentData: NSObject, NSCoding {
    var date: String = ""
    var total: Double = 0.0
    var percentage: Int = 0
        
    init(date: String, total: Double, percentage: Int) {
        self.date = date
        self.total = total
        self.percentage = percentage
    }
    
    required init(coder aDecoder: NSCoder) {
        if let date = aDecoder.decodeObject(forKey: "date") as? String {
            self.date = date
        }
        
        total = aDecoder.decodeDouble(forKey: "total")
        percentage = aDecoder.decodeInteger(forKey: "percentage")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: "date")
        aCoder.encode(total, forKey: "total")
        aCoder.encode(percentage, forKey: "percentage")
    }
    
    override var description: String {
        get {
            return "\(date) \(total) \(percentage)"
        }
    }
}
