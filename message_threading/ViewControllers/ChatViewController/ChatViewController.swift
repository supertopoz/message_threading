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
//        query?.includeReplies = true
//        query?.includeThreadInfo = true
        query?.reverse = true
        query?.loadPreviousMessages(withLimit: 30, reverse: false, completionHandler: { (messages, error) in
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
                    guard error == nil else {   // Error.
                        print(error)
                        return
                    }
                    if let message = userMessage {
                        DispatchQueue.main.async{
                            self.parentMessageStore?[0] = message
                            self.messageTableView.reloadData();
                        }
                    }
                })
            DispatchQueue.main.async{
                print(message.sendingStatus.rawValue)
                self.parentMessageStore?.insert(message, at: 0)
                self.messageTableView.reloadData();
            }

            }
        }

}
