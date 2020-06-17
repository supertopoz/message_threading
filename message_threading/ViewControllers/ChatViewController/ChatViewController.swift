//
//  ViewController.swift
//  message_threading
//
//  Created by Jason.Allshorn on 2020/06/04.
//  Copyright © 2020 Jason.Allshorn. All rights reserved.
//

import UIKit
import SendBirdSDK

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SBDChannelDelegate {
    
    
    
    
    //  @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageTableView: UITableView!
    var currentChannel: SBDGroupChannel? = nil
    var parentMessageStore: [SBDBaseMessage]? = []
    @IBOutlet weak var messageInputField: UITextField!
    var otherUsersMessages: UINib!
    var myMessages: UINib!
    var adminMessages: UINib!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SBDMain.add(self as SBDChannelDelegate, identifier: "1")
        connectToSendbird()
        otherUsersMessages = UINib(nibName: "OtherUsersTableViewCell", bundle: nil)
        myMessages = UINib(nibName: "MyMessagesTableViewCell", bundle: nil)
        adminMessages = UINib(nibName: "AdminMessageTableViewCell", bundle: nil)
        let messageCells = (otherUsersMessages: otherUsersMessages!, myMessages: myMessages!, adminMessages: adminMessages!)
        initTableView(messageCells: messageCells)
        
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender:)))
        initKeyboardAdjustments(tap: tap)
    }
    
    @IBAction func getMessages(_ sender: Any) {
        let query = currentChannel?.createPreviousMessageListQuery()
        query?.reverse = true
        query?.loadPreviousMessages(withLimit: 30, reverse: false, completionHandler: { (messages, error) in
            guard error == nil else {
                self.showToast("Failed to fetch messages: \(String(describing: error?.localizedDescription))")
                return
            }
            self.showToast("Fetched 30 messages")
            self.parentMessageStore = messages?.reversed()
            self.messageTableView.reloadData();
        })
        
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        
        if messageInputField.text != "" {
            guard let params = SBDUserMessageParams(message: messageInputField.text!) else {
                print("Couldn't create params")
                return
                
            }
            let message = currentChannel!.sendUserMessage(with: params, completionHandler: { (userMessage, error) in
                guard error == nil else {
                    print(error)
                    return
                }
                if let message = userMessage {
                    DispatchQueue.main.async{
                        self.showToast("Sent successfully")
                        self.parentMessageStore?[0] = message
                        self.messageTableView.reloadData();
                    }
                }
            })
            DispatchQueue.main.async{
                self.showToast("Message sending...")
                self.parentMessageStore?.insert(message, at: 0)
                self.messageTableView.reloadData();
            }
            
        }
        messageInputField.text = ""
    }
    
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        if sender == self.currentChannel {
            guard let channel = self.currentChannel else { return }
            DispatchQueue.main.async {
                self.showToast("Message arrived!")
                self.parentMessageStore?.insert(message, at: 0)
                self.messageTableView.reloadData();
            }
        }
    }
}
