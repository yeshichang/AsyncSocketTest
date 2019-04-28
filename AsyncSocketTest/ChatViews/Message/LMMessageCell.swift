//
//  LMMessageCell.swift
//  AsyncSocketTest
//
//  Created by 叶世昌 on 2018/12/13.
//  Copyright © 2018 Luomi. All rights reserved.
//

import UIKit

class LMMessageCell: UITableViewCell {
    
    /// avatarImageView 头像
    lazy var avatarImageView: UIImageView = {
        let imageWH: CGFloat = 40
        let avatarImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: imageWH, height: imageWH))
        avatarImageView.isHidden = true
        avatarImageView.contentMode = .scaleAspectFit
        return avatarImageView
    }()
    
    /// 聊天背景图
    lazy var messageBackgroundImageView: UIImageView = {
        let messageBackgroundImageView = UIImageView()
        messageBackgroundImageView.isHidden = true
        return messageBackgroundImageView
    }()
    
    /// 消息发送状态
    var messageSendStatusImageView: UIImageView?
    
    var message: LMMessage? {
        didSet {
            avatarImageView.isHidden = false
            if (message?.body?.isFrom) ?? false {
                avatarImageView.image = nil
                /**
                 *  UIImageResizingModeStretch：拉伸模式，通过拉伸UIEdgeInsets指定的矩形区域来填充图片
                 UIImageResizingModeTile：平铺模式，通过重复显示UIEdgeInsets指定的矩形区域来填充图片
                 比如下面方法中的拉伸区域：UIEdgeInsetsMake(28, 20, 15, 20)
                 */
                messageBackgroundImageView.image = UIImage.init(named: "message_sender_background_normal")?.resizableImage(withCapInsets: UIEdgeInsets.init(top: 28, left: 20, bottom: 15, right: 20), resizingMode: .stretch)
                messageBackgroundImageView.highlightedImage = UIImage.init(named: "message_sender_background_normal")?.resizableImage(withCapInsets: UIEdgeInsets.init(top: 28, left: 20, bottom: 15, right: 20), resizingMode: .stretch)
                
            } else {
                avatarImageView.image = nil
                messageBackgroundImageView.image = UIImage.init(named: "message_receiver_background_normal")?.resizableImage(withCapInsets: UIEdgeInsets.init(top: 28, left: 20, bottom: 15, right: 20), resizingMode: .stretch)
                messageBackgroundImageView.highlightedImage = UIImage.init(named: "message_receiver_background_highlight")?.resizableImage(withCapInsets: UIEdgeInsets.init(top: 28, left: 20, bottom: 15, right: 20), resizingMode: .stretch)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        contentView.addSubview(messageBackgroundImageView)
        contentView.addSubview(avatarImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (message?.body?.isFrom) ?? false {
            // 屏幕宽 - 10 - 头像宽
            avatarImageView.origin = CGPoint.init(x: frameWidth - 10 - avatarImageView.frameWidth, y: 10)
        } else {
            avatarImageView.origin = CGPoint.init(x: 10, y: 10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
