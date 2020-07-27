//
//  AdminMessageModel.swift
//  message_threading
//
//  Created by Jason.Allshorn on 2020/06/16.
//  Copyright © 2020 Jason.Allshorn. All rights reserved.
//

import Foundation
import SendBirdSDK
import UIKit

struct AdminMessageBubble  {
    let adminMessage: SBDAdminMessage
    let view: AdminMessageView
    init(messageObj: SBDAdminMessage, messageBubble: AdminMessageView) {
        self.adminMessage = SBDAdminMessage.init()
        self.view = messageBubble
        self.view.adminMessageLabel.text = messageObj.message
        self.view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
    }
    func createView() -> UIView {
        return self.view
    }
}
