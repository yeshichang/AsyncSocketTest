//
//  LMMessage.swift
//  AsyncSocketTest
//
//  Created by 叶世昌 on 2018/12/13.
//  Copyright © 2018 Luomi. All rights reserved.
//

import UIKit
import RealmSwift

class LMConversion: Object {
    
    @objc dynamic var conversionId: NSNumber = 0
    
    // 主键
    override static func primaryKey() -> String? {
        return "conversionId"
    }
   
}

class LMMessage: Object {
    
    @objc dynamic var body: LMMessageBody?
    
    @objc dynamic var cmd: NSNumber = 0
    
    @objc dynamic var msgid: NSNumber = 0
    
    @objc dynamic var type: NSNumber = 0
    
    @objc dynamic var id: NSNumber = 0
    
    @objc dynamic var time: Date = Date()
    
    @objc dynamic var sid: NSNumber = 0
        
    // 索引属性
    override static func indexedProperties() -> [String] {
        return ["msgid"]
    }
    
    // 主键
    override static func primaryKey() -> String? {
        return "sid"
    }
}

class LMMessageBody: Object {
    
    @objc dynamic var from: String? = nil
    
    @objc dynamic var msg: String? = nil
    
    @objc dynamic var to: String? = nil
    
}
