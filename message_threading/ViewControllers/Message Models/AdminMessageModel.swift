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

struct AdminMessageCell  {
    let adminMessage: SBDAdminMessage
    let cell: AdminMessageTableViewCell
    init(messageObj: SBDAdminMessage, table: UITableView) {
        self.adminMessage = SBDAdminMessage.init()
        self.cell = table.dequeueReusableCell(withIdentifier: "AdminMessages")! as! AdminMessageTableViewCell
        self.cell.adminMessageLabel.text = messageObj.message
        self.cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
    }
    func createCell() -> UITableViewCell {
        return self.cell
    }
}
