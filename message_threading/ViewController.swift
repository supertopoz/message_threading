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
        query?.includeReplies = true
        query?.includeThreadInfo = true
        query?.loadPreviousMessages(withLimit: 30, reverse: false, completionHandler: { (messages, error) in
            print(messages)
            self.parentMessageStore = messages
            self.parentMessages.reloadData();
        })

    }
}

extension ViewController {
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

extension ViewController {
    
    func connectToSendbird(){
        SBDMain.connect(withUserId: "User11", completionHandler: { (user, error) in
            guard error == nil else {
                print(error)
                return
                
            }
            print("Connected")
            let channelUrl = "sendbird_group_channel_127670705_a923ca4eebd7ae5e487f1c693a75982b85831b4a"
            SBDGroupChannel.getWithUrl(channelUrl) { (channel, error) in
                guard error == nil else {
                    print(error)
                    return
                    
                }
                self.currentChannel = channel
            }
        })
    }

}

extension ViewController {
    
    func initKeyboardAdjustments(tap: UITapGestureRecognizer){
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleScreenTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }

    @objc func keyboardWillChange(notification: NSNotification) {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if messageInputField.isFirstResponder {
                self.view.frame.origin.y = -keyboardSize.height
            }
        }
    }
}

extension ViewController {
    
    func initTableView(nib: UINib) {
        parentMessages.register(nib, forCellReuseIdentifier: "ParentMessages")
        parentMessages.estimatedRowHeight = 200
        parentMessages.rowHeight = UITableView.automaticDimension
        parentMessages.separatorColor = .clear
        parentMessages.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi))
        parentMessages.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: parentMessages.bounds.size.width - 8.0)
    }
    
}

