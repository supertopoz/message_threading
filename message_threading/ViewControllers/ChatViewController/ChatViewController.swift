//
//  ViewController.swift
//  message_threading
//
//  Created by Jason.Allshorn on 2020/06/04.
//  Copyright © 2020 Jason.Allshorn. All rights reserved.
//

import UIKit
import SendBirdSDK
import VirgilE3Kit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SBDChannelDelegate, SBDConnectionDelegate {
    
    
    
    
    //  @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageTableView: UITableView!
    
    var currentChannel: SBDGroupChannel? = nil
   // let dic = [ String(): ["parent": SBDBaseMessage(), "replies": [SBDBaseMessage()]]] as [String : Any]
    var parentMessageStore: [SBDBaseMessage]? = []
    @IBOutlet weak var messageInputField: UITextField!
    var otherUsersMessages: UINib!
    var myMessages: UINib!
    var adminMessages: UINib!
    let loginUserId = "Alice"
    var currentUser: SBDUser? = nil
    
    override func viewDidLoad() {
        
        //tableView = UITableView(frame: .zero, style: .grouped)
        super.viewDidLoad()
        SBDMain.add(self as SBDChannelDelegate, identifier: "1")
        initConnections()
        otherUsersMessages = UINib(nibName: "OtherUsersTableViewCell", bundle: nil)
        myMessages = UINib(nibName: "MyMessagesTableViewCell", bundle: nil)
        adminMessages = UINib(nibName: "AdminMessageTableViewCell", bundle: nil)
        let messageCells = (otherUsersMessages: otherUsersMessages!, myMessages: myMessages!, adminMessages: adminMessages!)
        initTableView(messageCells: messageCells)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender:)))
        initKeyboardAdjustments(tap: tap)
    }
    
    @IBAction func getMessages(_ sender: Any) {
        
        if let connected = currentUser?.connectionStatus.rawValue {
            print(connected)
        }
        let query = currentChannel?.createPreviousMessageListQuery()
        query?.reverse = true
        query?.includeThreadInfo = true
        query?.includeReplies = true
        query?.loadPreviousMessages(withLimit: 30, reverse: false, completionHandler: { (messages, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                 self.showToast("Failed to fetch messages: \(String(describing: error?.localizedDescription))")
                }
                
                return
            }
            DispatchQueue.main.async {
                self.showToast("Fetched 30 messages")
            }
            self.parentMessageStore = messages?.reversed()
            self.messageTableView.reloadData();
        })        
    }
    
    @IBAction func clearCurrentUser(_ sender: Any) {
        VirgilClient.shared.clearUser(completion: {(result, error) in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            print("User removed")
        })
    }
    
    @IBAction func rotateUsersPrivateKey(_ sender: Any) {
        VirgilClient.shared.rotatateUsersPrivateKey(completion: {(result, error) in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            print(result)
        })
    }
    
    
    
    func getChannelMembers () -> [String] {


        let members = currentChannel?.members
        var identities:[String] = []
        for member in (members! as NSArray as! [SBDMember]) {
            let memberObj: SBDMember
            memberObj = member
            identities.append(memberObj.userId)
        }
        let currentUserID = SBDMain.getCurrentUser()?.userId
        let indexOfCurrentUser = identities.firstIndex(of: currentUserID!)!
        identities.remove(at: indexOfCurrentUser)
        return identities
    }

    
    @IBAction func sendMessage(_ sender: Any) {
        
        
        if messageInputField.text != "" {
            guard let params = SBDUserMessageParams(message: "Encrypted Message") else {
                print("Couldn't create params")
                return
            }
            let userMessage = self.messageInputField.text!
            let channelMembers = getChannelMembers()
            VirgilClient.shared.prepareUsers(with: channelMembers, completion: {(error) in
                guard error == nil else {
                    if let message = error?.localizedDescription {
                        DispatchQueue.main.async {
                            self.showToast(message)
                        }
                    }
                    return
                }
                let eMessage = VirgilClient.shared.encrypt(userMessage, for: self.getChannelMembers()[0])
                params.data = eMessage
                params.customType = "ENCRYPTED"
                DispatchQueue.main.async{
                    self.showToast("Message Encrypted")
                }
                let message = self.currentChannel!.sendUserMessage(with: params, completionHandler: { (userMessage, error) in
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
            })
            
            
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
