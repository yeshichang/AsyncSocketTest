//
//  LMChatController.swift
//  AsyncSocketTest
//
//  Created by 叶世昌 on 2018/12/13.
//  Copyright © 2018 Luomi. All rights reserved.
//

import UIKit

class LMChatController: UIViewController, LMChatMessageControllerDelegate, LMChatBoxControllerDelegate {
    
    func chatBoxViewController(chatboxViewController: LMChatBoxController, didChangeChatBoxHeight height: CGFloat) {
        
    }
    
    func chatBoxViewController(chatboxViewController: LMChatBoxController, sendMessage message: LMMessage) {
        
    }
    
    
    func didTapChatMessageView(chatMessageViewController: LMChatMessageController) {
        chatBoxVC.resignFirstResponder()
    }
    
    
    let viewHeight = UIScreen.main.bounds.height - 20 - 44;
    
    // MARK: - 两个聊天界面控制器
    private lazy var chatMessageVC: LMChatMessageController = {
        let chatMessageVC = LMChatMessageController()
        chatMessageVC.view.frame = CGRect.init(x: 0, y: 20 + 44, width: UIScreen.main.bounds.width, height: viewHeight)
        chatMessageVC.delegate = self
        return chatMessageVC
    }()

    private lazy var chatBoxVC: LMChatBoxController = {
        let chatBoxVC = LMChatBoxController()
        chatBoxVC.view.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height - 49, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        chatBoxVC.delegate = self
        return chatBoxVC
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.addSubview(chatMessageVC.view)
        addChild(chatMessageVC)
        view.addSubview(chatBoxVC.view)
        addChild(chatBoxVC)
    }
    


    
}
