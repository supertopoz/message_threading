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
    
    func initTableView(nib: UINib) {
        parentMessages.register(nib, forCellReuseIdentifier: "ParentMessages")
        parentMessages.estimatedRowHeight = 200
        parentMessages.rowHeight = UITableView.automaticDimension
        parentMessages.separatorColor = .clear
        parentMessages.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi))
        parentMessages.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: parentMessages.bounds.size.width - 8.0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parentMessageStore?.count ?? 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = parentMessages.dequeueReusableCell(withIdentifier: "ParentMessages")! as! ParentMessTableViewCell
        if let message = self.parentMessageStore?[indexPath[1]] {
            //  let msg: SBDBaseMessage = message
            if message is SBDUserMessage {
                
                var userMessage = SBDUserMessage.init()
                userMessage.self = message as! SBDUserMessage
                cell.messageIdLabel.text = "\( String(userMessage.sender?.nickname ?? ""))"
                cell.messageMessageLabel.text = "\( String(userMessage.message ?? ""))"
            } else {
                cell
            }
            print(message)
        }
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
