//
//  OtherUserMessageModel.swift
//  message_threading
//
//  Created by Jason.Allshorn on 2020/06/16.
//  Copyright © 2020 Jason.Allshorn. All rights reserved.
//

import Foundation
import SendBirdSDK
import UIKit

struct OtherUserCell {
    let messageId: Int64
    let otherUserMessage: SBDUserMessage
    let cell: OtherUsersTableViewCell
    init(messageObj: SBDUserMessage, table: UITableView) {
        self.messageId = messageObj.messageId
        self.otherUserMessage = SBDUserMessage.init()
        self.cell = table.dequeueReusableCell(withIdentifier: "OtherUserMessages") as! OtherUsersTableViewCell
        cell.senderLabel.text = "\( String(messageObj.sender?.nickname ?? ""))"
        cell.messageLabel.text = "\( String(messageObj.message ?? ""))"
        self.cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        if messageObj.customType == "ENCRYPTED" {
            
            cell.messageLabel.text = VirgilClient.shared.decrypt(messageObj.data!)
        }
    }
    func createCell() -> UITableViewCell {
        return self.cell
    }
}

struct OtherUserParentMessage {
    let otherUserMessage: SBDUserMessage
    let messageBubble: OtherUsersReplyMessageView
    init(messageObj: SBDUserMessage, messageBubble: OtherUsersReplyMessageView, isReply: Int64) {
        self.otherUserMessage = SBDUserMessage.init()
       
        self.messageBubble = messageBubble
        if(isReply == 0){
            self.messageBubble.restrictedWidthHolderView.backgroundColor = .white
//self.messageBubble.repliesCountLabel.text = ""
        } else {
            if isReply != 0  {
               // self.messageBubble.repliesCountLabel.text = "Is reply"
            } else {
            }
        }
        let timestamp = GetMessageTimestamp(from: messageObj.createdAt)
        
        messageBubble.sentTimestampLabel.text = timestamp.showTime()
        messageBubble.message.text = "\( String(messageObj.message ?? ""))"
        if let nickname = messageObj.sender?.nickname {
          //  messageBubble.senderNicknameLabel.text = nickname
        } else {
          //  messageBubble.senderNicknameLabel.text = ""
        }
        messageBubble.roundCorners(view: messageBubble.repliedMessageContainerView, corners: [.topLeft, .topRight], radius: 10)
        messageBubble.messageBackgroundView.layer.cornerRadius = 10
        messageBubble.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi))
        if messageObj.customType == "ENCRYPTED" {
            messageBubble.message.text = VirgilClient.shared.decrypt(messageObj.data!)
        }
    }
    func createView() -> UIView {
        return self.messageBubble
    }
}
