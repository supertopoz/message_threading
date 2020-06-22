//
//  MyMessageModel.swift
//  message_threading
//
//  Created by Jason.Allshorn on 2020/06/16.
//  Copyright © 2020 Jason.Allshorn. All rights reserved.
//

import Foundation
import SendBirdSDK
import UIKit


struct MyMessageCell  {
    let messageId: Int64
    let userMessage: SBDUserMessage
    let cell: MyMessagesTableViewCell
    init(messageObj: SBDUserMessage, table: UITableView) {
        self.messageId = messageObj.messageId
        self.userMessage = SBDUserMessage.init()
        self.cell = table.dequeueReusableCell(withIdentifier: "MyMessages")! as! MyMessagesTableViewCell
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
