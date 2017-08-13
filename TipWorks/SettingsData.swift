//
//  SettingsData.swift
//  TipWorks
//
//  Created by Tuan-Lung Wang on 8/12/17.
//  Copyright © 2017 Tuan-Lung Wang. All rights reserved.
//

import Foundation

class SettingsData: NSObject, NSCoding {
    
    var tipOptions: [Int] = []
    var defaultTipOption: Int = 0
    var maxNumToSplit: Int = 10
    var languageOption: Int = 0
    
    override init() {}
    
    required init(coder aDecoder: NSCoder) {
        if let tipOptions = aDecoder.decodeObject(forKey: "tipOptions") as? [Int] {
            self.tipOptions = tipOptions
        }
        
        defaultTipOption = aDecoder.decodeInteger(forKey: "defaultTipOption")
        maxNumToSplit = aDecoder.decodeInteger(forKey: "maxNumToSplit")
        languageOption = aDecoder.decodeInteger(forKey: "languageOption")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(tipOptions, forKey: "tipOptions")
        aCoder.encode(defaultTipOption, forKey: "defaultTipOption")
        aCoder.encode(maxNumToSplit, forKey: "maxNumToSplit")
        aCoder.encode(languageOption, forKey: "languageOption")
    }
}
