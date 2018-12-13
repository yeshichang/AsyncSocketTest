//
//  LMChatManager.swift
//  AsyncSocketTest
//
//  Created by 叶世昌 on 2018/12/12.
//  Copyright © 2018 Luomi. All rights reserved.
//

import UIKit

enum LMMessgecmd: NSNumber {
    
    case register = 101
    case registerSuccess = 201
    case clientAToServer = 1001
    case serverToClientB = 2001
    case clientBToServer = 1002
    case serverToClientA = 2002
    case serverToClientA_clientBOffline = 2003
    case serverHeaderBeat = 4001
    
    static func getSelf(number: NSNumber) -> LMMessgecmd {
        switch number {
        case 101:
            return .register
        case 201:
            return .registerSuccess
        case 1001:
            return .clientAToServer
        case 2001:
            return .serverToClientB
        case 1002:
            return .clientBToServer
        case 2002:
            return .serverToClientA
        case 2003:
            return .serverToClientA_clientBOffline
        default:
            return .serverHeaderBeat
        }
    }
}

class LMClient: NSObject {

    /// 单例
    static let shared = LMClient()
    
    lazy var timer: Timer = {
        let timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(headerBeat), userInfo: nil, repeats: true)
        return timer
    }()
    
    /// 启动和暂停定时器
    private func openOrPauseTimer(openTimer: Bool) {
        if openTimer {
            timer.fireDate = Date.init()
        } else {
            timer.fireDate = Date.distantFuture
        }
    }
        
    
    /// 初始化 链接服务器
    private override init() {
        super.init()
        
        connectServer(callBack: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EnterBack), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    
    /// socket
    lazy var asyncSocket = GCDAsyncSocket.init(delegate: self, delegateQueue: DispatchQueue.main)
    
    /// 链接服务器
    public func connectServer(callBack: ((_ isSuccess: Bool, _ error: Error?) -> Void)?) {
        if asyncSocket.isDisconnected {
            do {
                try asyncSocket.connect(toHost: "221.195.1.254", onPort: 8030)
            } catch {
                callBack?(false, error)
            }
        }
    }
    
    /// 断开链接
    public func disConnectServer() {
        if asyncSocket.isConnected {
            asyncSocket.disconnectAfterReadingAndWriting()
        }
    }
    
    @objc private func headerBeat() {
        chatManager.headerBeat()
        asyncSocket.readData(withTimeout: reciveMessageTimeOut, tag: 0)
    }
    
    @objc private func BecomeActive() {
        // 重新连接服务器
        connectServer(callBack: nil)
        openOrPauseTimer(openTimer: true)
    }
    
    @objc private func EnterBack() {
        openOrPauseTimer(openTimer: false)
    }
    
    /// 单聊manager
    let chatManager = LMChat_Manager()
}

extension LMClient: GCDAsyncSocketDelegate {
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        
        chatManager.socket(sock, didRead: data, withTag: tag)
        
    }
    
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        
        chatManager.socket(sock, didWriteDataWithTag: tag)
        
    }
    
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        
        chatManager.socket(sock, didConnectToHost: host, port: port)
        
        print("didConnectToHost \(host)    \(port)")
        
        
        chatManager.registerCmd()
        
        // 开启心跳
        openOrPauseTimer(openTimer: true)
    }
    
    func socket(_ sock: GCDAsyncSocket, didReadPartialDataOfLength partialLength: UInt, tag: Int) {
        
        chatManager.socket(sock, didReadPartialDataOfLength: partialLength, tag: tag)
        
        print("Received bytes：\(partialLength)")
    }
}
