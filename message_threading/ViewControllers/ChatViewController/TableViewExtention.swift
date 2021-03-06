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
        
        messageTableView.estimatedRowHeight = 150
        messageTableView.rowHeight = UITableView.automaticDimension
        
        messageTableView.sectionHeaderHeight =  UITableView.automaticDimension
        messageTableView.estimatedSectionHeaderHeight = 150;
        
        messageTableView.separatorColor = .clear
        messageTableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi))
        messageTableView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: messageTableView.bounds.size.width - 8.0)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return parentMessageStore?.count ?? 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let currentUserId = SBDMain.getCurrentUser()?.userId
        let headerView = OtherUsersReplyMessageView()
        if let message = self.parentMessageStore?[section - 1] {
            let isReply = message.parentMessageId
            if message is SBDUserMessage {
                var userMessage = SBDUserMessage.init()
                userMessage.self = message as! SBDUserMessage
                let senderId = userMessage.sender?.userId
                if senderId == currentUserId {
//                    let otherUserParentMessage = OtherUserParentMessage(messageObj: message as! SBDUserMessage, messageBubble: headerView, numberOfReplies: replyCount)
//                    return otherUserParentMessage.createView()
                } else {
                    let otherUserParentMessage = OtherUserParentMessage(messageObj: message as! SBDUserMessage, messageBubble: headerView, isReply: isReply )
                    return otherUserParentMessage.createView()
                }
            }
            if message is SBDAdminMessage {
                print("Admin message found")
                let adminMessageView = AdminMessageView()
                adminMessageView.adminMessageLabel.text = "Hello"
                let adminMessageBubble = AdminMessageBubble(messageObj: message as! SBDAdminMessage, messageBubble: adminMessageView )
                return adminMessageBubble.createView()
            }
        }
        if(section > 0 ){
            return headerView
        } else {
            let view = UIView()
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 0 {
            return UITableView.automaticDimension
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0// section + 1 * 2//parentMessageStore?.count ?? 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentUserId = SBDMain.getCurrentUser()?.userId
        var cell = UITableViewCell()// messageTableView.dequeueReusableCell(withIdentifier: "OtherUsersMessages")! as! OtherUsersTableViewCell
        if let message = self.parentMessageStore?[indexPath[1]] {
            //            if message is SBDUserMessage {
            //                var userMessage = SBDUserMessage.init()
            //                userMessage.self = message as! SBDUserMessage
            //                let senderId = userMessage.sender?.userId
            //                if senderId == currentUserId {
            //                    let myMessageCell = MyMessageCell(messageObj: message as! SBDUserMessage, table: messageTableView)
            //                    return myMessageCell.createCell()
            //                } else {
            //                    let otherUserMessage = OtherUserCell(messageObj: message as! SBDUserMessage, table: messageTableView)
            //                    return otherUserMessage.createCell()
            //                }
            //            }
        }
        return cell
    }
    
    
    
}
