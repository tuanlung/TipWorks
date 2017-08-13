//
//  Storage.swift
//  TipWorks
//
//  Created by Tuan-Lung Wang on 8/12/17.
//  Copyright © 2017 Tuan-Lung Wang. All rights reserved.
//

import Foundation

class Storage {
    class func save(key: String, value: Any) {
        let defaults = UserDefaults.standard
        
        defaults.set(NSKeyedArchiver.archivedData(withRootObject: value), forKey: key)
        
        defaults.synchronize()
    }
    
    class func load(key: String) -> Any? {
        let defaults = UserDefaults.standard
        
        if let data = defaults.object(forKey: key) as? NSData {
            return NSKeyedUnarchiver.unarchiveObject(with: data as Data)
        }
        return nil
    }
}
