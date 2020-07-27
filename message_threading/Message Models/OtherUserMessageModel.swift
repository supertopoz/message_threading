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
    let messageId: Int64
    let otherUserMessage: SBDUserMessage
    let messageBubble: OtherUsersParentMessageView
    init(messageObj: SBDUserMessage, messageBubble: OtherUsersParentMessageView, numberOfReplies: Int) {
        self.messageId = messageObj.messageId
        self.otherUserMessage = SBDUserMessage.init()
        self.messageBubble = messageBubble
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss"
        if(numberOfReplies == 0){
        //    self.messageBubble.restrictedWidthHolderView.backgroundColor = .white
        }
        messageBubble.sentTimestampLabel.text = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(messageObj.createdAt/1000)))
        messageBubble.message.text = "\( String(messageObj.message ?? ""))"
        messageBubble.senderNicknameLabel.text = messageObj.sender?.nickname as! String
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
