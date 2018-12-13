//
//  ViewController.swift
//  AsyncSocketTest
//
//  Created by 叶世昌 on 2018/12/11.
//  Copyright © 2018 Luomi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    var ay: GCDAsyncSocket?
    
    var stream: OutputStream?
    var readBytes: Int = 0
    var byteIndex: Int = 0
    
    var headerTimer: Timer?
    
    
    var chatManager = LMClient.shared.chatManager
    
    override func viewDidLoad() {
            
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(NSHomeDirectory())
        
        chatManager.add(self)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @IBAction func sendText(_ sender: Any) {

        chatManager.sendText(textField.text!)
        
        textView.text = "\(textView.text!)\n我说：\(textField.text!)"
        
        textField.text = nil
    }
    
}

extension ViewController: LMChat_ManagerDelegate {
    
    func messageDidReceive(message: LMJsonMessage?) {
        guard let message = message else {
            return
        }
        
        switch LMMessgecmd.getSelf(number: message.cmd) {
        case .register:
            break
        case .registerSuccess:
            break
        case .clientAToServer:
            break
        case .serverToClientB:
            textView.text = "\(textView.text!)\nTa说：\(message.body!.msg!)"
            break
        case .clientBToServer:
            break
        case .serverToClientA:
            break
        case .serverToClientA_clientBOffline:
            break
        case .serverHeaderBeat:
            break
        }
        print(message.body?.from ?? "nil")
    }
    
}
