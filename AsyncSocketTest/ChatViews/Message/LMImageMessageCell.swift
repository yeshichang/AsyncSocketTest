//
//  LMImageMessageCell.swift
//  AsyncSocketTest
//
//  Created by 叶世昌 on 2018/12/13.
//  Copyright © 2018 Luomi. All rights reserved.
//

import UIKit

class LMImageMessageCell: LMMessageCell {
    
    override var message: LMMessage? {
        didSet {
            // TODO: - 设置图片
            
            if message?.body?.isFrom ?? false {
                messageBackgroundImageView.image = UIImage.init(named: "message_sender_background_reversed")?.resizableImage(withCapInsets: UIEdgeInsets.init(top: 28, left: 20, bottom: 15, right: 20), resizingMode: .stretch)
                
            } else {
                messageBackgroundImageView.highlightedImage = UIImage.init(named: "message_receiver_background_reversed")?.resizableImage(withCapInsets: UIEdgeInsets.init(top: 28, left: 20, bottom: 15, right: 20), resizingMode: .stretch)
            }
        }
    }
    
    lazy var messageImageView: UIImageView = {
       let messageImageView = UIImageView.init()
        messageImageView.contentMode = .scaleAspectFill
        messageImageView.clipsToBounds = true
        return messageImageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(messageImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let y: CGFloat = avatarImageView.originY - 3
        if message?.body?.isFrom ?? false {
            let x = avatarImageView.originY - messageImageView.frameWidth - 5
            messageImageView.origin = CGPoint.init(x: x, y: y)
            messageBackgroundImageView.frame = CGRect.init(x: x, y: y, width: 100, height: 100)
        } else {
            let x = avatarImageView.originX + avatarImageView.frameWidth + 5
            messageImageView.origin = CGPoint.init(x: x, y: y)
            messageBackgroundImageView.frame = CGRect.init(x: x, y: y, width: 100, height: 100)
        }
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
