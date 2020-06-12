//
//  ViewController.swift
//  message_threading
//
//  Created by Jason.Allshorn on 2020/06/04.
//  Copyright © 2020 Jason.Allshorn. All rights reserved.
//

import UIKit
import SendBirdSDK

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    @IBOutlet weak var parentMessages: UITableView!
    var currentChannel: SBDGroupChannel? = nil
    var parentMessageStore: [SBDBaseMessage]? = []
    @IBOutlet weak var messageInputField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectToSendbird()
        let nib = UINib(nibName: "ParentMessTableViewCell", bundle: nil)
        initTableView(nib: nib)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender:)))
        initKeyboardAdjustments(tap: tap)
    }
    
    @IBAction func getMessages(_ sender: Any) {
        let query = currentChannel?.createPreviousMessageListQuery()
//        query?.includeReplies = true
//        query?.includeThreadInfo = true
        query?.reverse = true
        query?.loadPreviousMessages(withLimit: 30, reverse: false, completionHandler: { (messages, error) in
            print(messages)
            self.parentMessageStore = messages?.reversed()
            self.parentMessages.reloadData();
        })
        
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        print(messageInputField.text)
        guard let params = SBDUserMessageParams(message: messageInputField.text!) else {
            print("Couldn't create params")
            return
            
        }
        
        currentChannel!.sendUserMessage(with: params, completionHandler: { (userMessage, error) in
            guard error == nil else {   // Error.
                print(error)
                return
            }
        })
    }
}
