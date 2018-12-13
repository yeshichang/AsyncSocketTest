//
//  LMMessage.swift
//  AsyncSocketTest
//
//  Created by 叶世昌 on 2018/12/12.
//  Copyright © 2018 Luomi. All rights reserved.
//

import UIKit

@objcMembers
class LMJsonMessage: NSObject {

    var body: LMJsonMessageBody?
    
    var cmd: NSNumber!
    
    var msgid: NSNumber?
    
    var type: NSNumber?
    
    var id: NSNumber?
    
    var sid: String?
    
    var time: NSNumber?
    
    
    override init() {
        super.init()
    }
}

@objcMembers
class LMJsonMessageBody: NSObject {
    
    var from: String!
    
    var msg: String?
    
    var to: String?
    
    override init() {
        super.init()
    }
}
