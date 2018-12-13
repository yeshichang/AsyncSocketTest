//
//  LMChatManagerCenter.swift
//  AsyncSocketTest
//
//  Created by 叶世昌 on 2018/12/12.
//  Copyright © 2018 Luomi. All rights reserved.
//

import UIKit
import RealmSwift

/// 验证真机模拟器
enum Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }()
}


let SendMessageTimeOut: TimeInterval = 10
let reciveMessageTimeOut: TimeInterval = 60*60*24
let fromto = Platform.isSimulator ? ("32" , "38") : ("38" , "32")

protocol LMChat_ManagerDelegate: class {
    
    /// 接收到消息
    ///
    /// - Parameter message: message模型
    func messageDidReceive(message: LMJsonMessage?)
}

class LMChat_Manager: NSObject {

    
    /// conversion
    var conversion: LMConversion?
    
    /// 数据库单例
    private lazy var realm: Realm = {
        let realm = try! Realm.init()
        return realm
    }()
  
    
    weak var delegate: LMChat_ManagerDelegate?
    
    /// addDelegate
    public func add(_ delegate: Any) {
        self.delegate = delegate as? LMChat_ManagerDelegate
    }
    
    /// removeDelegate
    public func remove(_ delegate: Any) {
       self.delegate = nil
    }
    
    /// msgid 自增
    var msgid: NSNumber = 0
    
    /// 链接服务器成功后注册
    func registerCmd() {
        
        guard let data = cmdMessage(cmd: .register) else {
            return
        }
        LMClient.shared.asyncSocket.write(data, withTimeout: SendMessageTimeOut, tag: 101)
    }
    
    /// 心跳给服务器
    func headerBeat() {
        guard let data = cmdMessage(cmd: .serverHeaderBeat) else {
            return
        }
        LMClient.shared.asyncSocket.write(data, withTimeout: SendMessageTimeOut, tag: 101)
    }
    
    /// 发送文字消息 A->server
    func sendText(_ text: String) {
        
        guard let data = textMessage(text, cmd: .clientAToServer, msgid: msgid) else {
            return
        }
       
        LMClient.shared.asyncSocket.write(data, withTimeout: SendMessageTimeOut, tag: 101)
    }
    
    /// 透传消息message
    private func cmdMessage(cmd: LMMessgecmd) -> Data? {
        let body = LMJsonMessageBody.init()
        body.from = fromto.0
        let message = LMJsonMessage.init()
        message.cmd = cmd.rawValue
        message.msgid = 0
        message.type = 0
        message.body = body
        
        let jsonStr = message.mj_JSONString()
        return encodeMessage(jsonStr: jsonStr)
    }
    
    /// 组装message
    private func textMessage(_ text: String, cmd: LMMessgecmd, msgid: NSNumber?) -> Data? {
        
        let from = fromto.0
        let to = fromto.1
        let conversionId =  (Int(from)! > Int(to)!) ? "\(from)_\(to)" : "\(to)_\(from)"
        
        // 发送message
        if conversion != nil {

            let body = LMJsonMessageBody.init()
            body.from = fromto.0
            body.msg = text
            body.to = fromto.1
            let message = LMJsonMessage.init()
            message.cmd = cmd.rawValue
            message.msgid = msgid ?? 0
            message.type = 0
            message.body = body
        }
        
        // 1. 查询数据库是否存在conversionID
        
        let body = LMJsonMessageBody.init()
        body.from = fromto.0
        body.msg = text
        body.to = fromto.1
        let message = LMJsonMessage.init()
        message.cmd = cmd.rawValue
        message.msgid = msgid ?? 0
        message.type = 0
        message.body = body
        
//        let rmBody = LMJsonMessageBody.init()
//        rmBody.from = body.from
//        rmBody.msg = body.msg
//        rmBody.to = body.to
//        let rmMessage = LMJsonMessage.init()
//        rmMessage.msgid = message.msgid ?? 0
//        rmMessage.cmd = message.cmd
//        rmMessage.body = rmBody
//        rmMessage.type = message.type ?? 0
//        rmMessage.id = message.id ?? 0
//        rmMessage.time = Date.init(timeIntervalSince1970: TimeInterval(truncating: message.time!))
//        let sid = LMConversion.init()
//        sid.sid = message.sid ?? ""
//        sid.message.append(rmMessage)
//
//        // 获取默认的 Realm 数据库
//        let realm = try! Realm()
//        try! realm.write {
//            realm.add(sid)
//        }
//
//        // 检索 Realm 数据库，找到小于 2 岁 的所有狗狗
//        let puppies = realm.objects(LMJsonMessage.self).filter("id < 2")
//        //puppies.count // => 0 因为目前还没有任何狗狗被添加到了 Realm 数据库中
//        print(puppies.count)
        
        
        let jsonStr = message.mj_JSONString()
        return encodeMessage(jsonStr: jsonStr)
        
    }
    
    /// 封装data
    private func encodeMessage(jsonStr: String?) -> Data? {
        
        guard let jsonStr = jsonStr else {
            return nil
        }
        
        let data = jsonStr.data(using: .utf8)!
        let bytes = [UInt8](data)
        let count = bytes.count
        
        // 创建byteBuffer
        let byteBuffer = ByteBuffer.init(size: count + 5)
        // 拼接头
        let b1: UInt8 = 0xff
        byteBuffer.put(b1)
        // 拼接count
        let b2 = Int32(count)
        byteBuffer.put(b2)
        // 拼接消息体
        for byte in bytes {
            byteBuffer.put(byte)
        }
        return Data(byteBuffer.getArr())
    }
    
    /// 解析message
    private func dencodeMessage(data: Data) -> LMJsonMessage? {
        
        let bytes = [UInt8](data)
        let count = bytes.count
        if count > 6 {
            let strBytes =  bytes[5..<count]
            
            let dict = try? JSONSerialization.jsonObject(with: Data(strBytes), options: .mutableContainers)
            print(dict ?? "")
            if dict == nil {
                return nil
            }
            let message = LMJsonMessage.mj_object(withKeyValues: dict)
            return message
        }
        return nil
    }
    
}

/// 会话
extension LMChat_Manager {
    
    // 搜索sid
    func searchConversionId(sid: String) -> LMConversion? {
        let predicate = realm.objects(LMConversion.self).filter("sid = \(sid)")
        if predicate.isEmpty {
            // 创建
            let conversion = LMConversion.init()
            do {
                try realm.write({
                    realm.add(conversion)
                })
                self.conversion = conversion
                return conversion
            } catch {
                print(error)
            }
        } else {
            // 获取到会话
            guard let conversion = predicate.first else {
                return nil
            }
            self.conversion = conversion
            return conversion
        }
        return nil
    }
    
}

extension LMChat_Manager {
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        
        delegate?.messageDidReceive(message: dencodeMessage(data: data))
    }
    
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {

    }
    
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        
    }
    
    func socket(_ sock: GCDAsyncSocket, didReadPartialDataOfLength partialLength: UInt, tag: Int) {
        
    }
}


