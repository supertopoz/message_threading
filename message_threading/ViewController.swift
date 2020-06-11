//
//  ViewController.swift
//  message_threading
//
//  Created by Jason.Allshorn on 2020/06/04.
//  Copyright © 2020 Jason.Allshorn. All rights reserved.
//

import UIKit
import SendBirdSDK

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    

    @IBOutlet weak var parentMessages: UITableView!
    var currentChannel: SBDOpenChannel? = nil
    var parentMessageStore: [SBDBaseMessage]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "ParentMessTableViewCell", bundle: nil)
        parentMessages.register(nib, forCellReuseIdentifier: "ParentMessages")
        SBDMain.connect(withUserId: "User1", completionHandler: { (user, error) in
            guard error == nil else { return }
            let channelUrl = "sendbird_open_channel_1268_27d2758cf4d381f6dc2df14e4b228bea50f1084b"
            SBDOpenChannel.getWithUrl(channelUrl) { (channel, error) in
                guard error == nil else { return }
                self.currentChannel = channel
            }
        })
        parentMessages.estimatedRowHeight = 200
        parentMessages.rowHeight = UITableView.automaticDimension
        parentMessages.separatorColor = .clear
        parentMessages.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi))
        parentMessages.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: parentMessages.bounds.size.width - 8.0)
        
    }
    
    @IBAction func getMessages(_ sender: Any) {
        let query = currentChannel?.createPreviousMessageListQuery()
        query?.includeReplies = true
        query?.includeThreadInfo = true
        query?.loadPreviousMessages(withLimit: 30, reverse: false, completionHandler: { (messages, error) in
            print(messages)
            self.parentMessageStore = messages
            self.parentMessages.reloadData();
        })

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parentMessageStore?.count ?? 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = parentMessages.dequeueReusableCell(withIdentifier: "ParentMessages")! as! ParentMessTableViewCell
        if let message = self.parentMessageStore?[indexPath[1]] {
          //  let msg: SBDBaseMessage = message
            if message is SBDUserMessage {
                cell.messageIdLabel.text = "Parent Message Id: \( String(message.messageId))"
                var userMessage = SBDUserMessage.init()
                userMessage.self = message as! SBDUserMessage
                cell.messageMessageLabel.text = "Message: \( String(userMessage.message ?? ""))"
            }
            
            
       
        }
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    

    


}

