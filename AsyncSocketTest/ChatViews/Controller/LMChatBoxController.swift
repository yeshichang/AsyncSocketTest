//
//  LMChatBoxController.swift
//  AsyncSocketTest
//
//  Created by 叶世昌 on 2018/12/13.
//  Copyright © 2018 Luomi. All rights reserved.
//

import UIKit

protocol LMChatBoxControllerDelegate: class {
    /// chatBoxView 高度改变
    func chatBoxViewController(chatboxViewController: LMChatBoxController, didChangeChatBoxHeight height: CGFloat)
    
    /// 发送消息
    func chatBoxViewController(chatboxViewController: LMChatBoxController, sendMessage message: LMMessage)
}

class LMChatBoxController: UIViewController, ZXChatBoxMoreViewDelegate, ZXChatBoxFaceViewDelegate, ZXChatBoxDelegate {
    
    func chatBox(_ chatBox: ZXChatBoxView!, changeStatusForm fromStatus: ZXChatBoxStatus, to toStatus: ZXChatBoxStatus) {
        
    }
    
    func chatBox(_ chatBox: ZXChatBoxView!, sendTextMessage textMessage: String!) {
        
    }
    
    func chatBox(_ chatBox: ZXChatBoxView!, changeChatBoxHeight height: CGFloat) {
        
    }
    
    func chatBoxFaceViewDidSelectedFace(_ face: ChatFace!, type: TLFaceType) {
        
    }
    
    func chatBoxFaceViewDeleteButtonDown() {
        
    }
    
    func chatBoxFaceViewSendButtonDown() {
        
    }
    
    func chatBoxMoreView(_ chatBoxMoreView: ZXChatBoxMoreView!, didSelect itemType: TLChatBoxItem) {
        
    }
    
    
    weak var delegate: LMChatBoxControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
