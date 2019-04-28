//
//  LMChatMessageController.swift
//  AsyncSocketTest
//
//  Created by 叶世昌 on 2018/12/13.
//  Copyright © 2018 Luomi. All rights reserved.
//

import UIKit

protocol LMChatMessageControllerDelegate: class {
    func didTapChatMessageView(chatMessageViewController: LMChatMessageController)
}

class LMChatMessageController: UITableViewController {

    weak var delegate: LMChatMessageControllerDelegate?
    
    /// 数据
    var data: [LMMessage] = [LMMessage]()
    
    /// 改变数据源方法，添加一条消息，刷新数据
    ///
    /// - Parameter message: 添加的消息
    public func addNewMessage(message: LMMessage) {
        data.append(message)
        tableView.reloadData()
    }
    
    /// 添加一条消息就让tableView滑动
    public func scrollToBottom() {
        if !data.isEmpty {
            // tableView 定位到的cell 滚动到相应的位置，后面的 atScrollPosition 是一个枚举类型
            tableView.scrollToRow(at: IndexPath.init(row: data.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
    
    lazy var tapGR: UITapGestureRecognizer = {
        let tapGR = UITapGestureRecognizer.init(target: self, action: #selector(didTapView))
        return tapGR
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(tapGR)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        tableView.register(LMTextMessageCell.self, forCellReuseIdentifier: "LMTextMessageCell")
        tableView.register(LMImageMessageCell.self, forCellReuseIdentifier: "LMImageMessageCell")
        tableView.register(LMVoiceMessageCell.self, forCellReuseIdentifier: "LMVoiceMessageCell")
        tableView.register(LMSystemMessageCell.self, forCellReuseIdentifier: "LMSystemMessageCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = data[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LMTextMessageCell", for: indexPath) as! LMMessageCell

        // Configure the cell...
        cell.message = message
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    @objc private func didTapView() {
        delegate?.didTapChatMessageView(chatMessageViewController: self)
    }

}
