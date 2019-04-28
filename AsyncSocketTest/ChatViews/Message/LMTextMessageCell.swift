//
//  LMTextMessageCell.swift
//  AsyncSocketTest
//
//  Created by 叶世昌 on 2018/12/13.
//  Copyright © 2018 Luomi. All rights reserved.
//

import UIKit

class LMTextMessageCell: LMMessageCell {
    
    override var message: LMMessage? {
        didSet {
            messageTextLabel.text = message?.body?.msg
            messageTextLabel.size = CGSize.init(width: 100, height: 40)
        }
    }

    lazy var messageTextLabel: UILabel = {
        let messageTextLabel = UILabel()
        messageTextLabel.font = UIFont.systemFont(ofSize: 16)
        messageTextLabel.numberOfLines = 0
        return messageTextLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(messageTextLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var y: CGFloat = avatarImageView.originY + 11
        var x: CGFloat = avatarImageView.originX + (message?.body?.isFrom ?? false ? -messageTextLabel.frameWidth - 27 : avatarImageView.frameWidth + 23)
        messageTextLabel.origin = CGPoint.init(x: x, y: y)
        
        x -= 18                             // 左边距离头像 5
        y = avatarImageView.originY - 5     // 上边与头像对齐 (北京图像有5个像素偏差)
        
        let h: CGFloat  = max(messageTextLabel.frameHeight + 30, avatarImageView.frameHeight + 10)
        messageBackgroundImageView.frame = CGRect.init(x: x, y: y, width: messageTextLabel.frameWidth + 40, height: h)
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
