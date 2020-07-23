//
//  TableViewExtention.swift
//  message_threading
//
//  Created by Jason.Allshorn on 2020/06/12.
//  Copyright © 2020 Jason.Allshorn. All rights reserved.
//

import Foundation
import UIKit
import SendBirdSDK

extension ChatViewController {
    
    func initTableView(messageCells: (otherUsersMessages: UINib, myMessages: UINib, adminMessages: UINib)) {
        
        messageTableView.register(messageCells.otherUsersMessages, forCellReuseIdentifier: "OtherUserMessages")
        messageTableView.register(messageCells.myMessages, forCellReuseIdentifier: "MyMessages")
        messageTableView.register(messageCells.adminMessages, forCellReuseIdentifier: "AdminMessages")
        
        messageTableView.estimatedRowHeight = 200
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.separatorColor = .clear
        messageTableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi))
        messageTableView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: messageTableView.bounds.size.width - 8.0)
    }
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return parentMessageStore?.count ?? 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))

        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "Notification Times \(section)"
        
        headerView.addSubview(label)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parentMessageStore?.count ?? 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         print("Working")
        let currentUserId = SBDMain.getCurrentUser()?.userId
        var cell = UITableViewCell()// messageTableView.dequeueReusableCell(withIdentifier: "OtherUsersMessages")! as! OtherUsersTableViewCell
    

        
        if let message = self.parentMessageStore?[indexPath[1]] {
            if message is SBDUserMessage {
                var userMessage = SBDUserMessage.init()
                userMessage.self = message as! SBDUserMessage

                let senderId = userMessage.sender?.userId
                if senderId == currentUserId {
                    let myMessageCell = MyMessageCell(messageObj: message as! SBDUserMessage, table: messageTableView)
                    return myMessageCell.createCell()
                } else {
                    let otherUserMessage = OtherUserCell(messageObj: message as! SBDUserMessage, table: messageTableView)
                    return otherUserMessage.createCell()
                }
            }

            if message is SBDAdminMessage {
                let adminMessageCell = AdminMessageCell(messageObj: message as! SBDAdminMessage, table: messageTableView)
                return adminMessageCell.createCell()
            }
        }
        return cell
        
        
        
        
    }
    
    
    
}
