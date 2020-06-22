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
    
    
    
    func encryptMessage (message: String) {
        
        // prepare a message
        let messageToEncrypt = "Hello, Alice and Den!"
        let identities = ["User11"]

        // Search user's Cards to encrypt for
//        self.eThree!.findUsers(with: identities) { findUsersResult, error in
//            guard let findUsersResult = findUsersResult, error == nil else {
//                // Error handling here
//                print(error?.localizedDescription)
//                return
//            }
//
//            do {
//                 let encryptedMessage = try self.eThree.authEncrypt(text: messageToEncrypt, for: findUsersResult)
//            } catch {
//                print(error.localizedDescription)
//            }
//
//        }
        
//        let members = currentChannel?.members
//        var identities:[String] = []
//        for member in (members! as NSArray as! [SBDMember]) {
//            let memberObj: SBDMember
//            memberObj = member
//            identities.append(memberObj.userId)
//        }
//        do {
//               let key = try self.virgil.eThree.hasLocalPrivateKey()
//            print("Found local private Key for current user")
//        } catch {
//            print("OOPS! no private key")
//            return
//        }
//        let currentUserID = SBDMain.getCurrentUser()?.userId
//        let indexOfCurrentUser = identities.firstIndex(of: currentUserID!)!
//        identities.remove(at: indexOfCurrentUser)
//        let indexOfDashboardAdmin = identities.firstIndex(of: "9e2c2921-a21a-4c10-91bb-c15cf6da417f")!
//        identities.remove(at: indexOfDashboardAdmin)
//        print(identities)
//        self.virgil.eThree.findUsers(with: identities){ findUsersResult, error in
//            guard let findUsersResult = findUsersResult, error == nil else {
//                print("VIGIL ERROR: \(String(describing: error?.localizedDescription))")
//                return
//            }
//            print(findUsersResult)
//            do {
//                   let key = try self.virgil.eThree.hasLocalPrivateKey()
//                print("Found local private Key for current user")
//            } catch {
//                print("OOPS! no private key")
//                return
//            }
//            do {
//                let encryptMessage = try self.virgil.eThree.authEncrypt(text: message, for: findUsersResult)
//                print(encryptMessage)
//                DispatchQueue.main.async {
//                    self.showToast("Messages: \(encryptMessage)")
//
//                }
//            } catch {
//
//                print(error.localizedDescription)
//            }
//        }
    }
        
    @IBAction func sendMessage(_ sender: Any) {
        
        
        if messageInputField.text != "" {
            guard let params = SBDUserMessageParams(message: "Encrypted Message") else {
                print("Couldn't create params")
                
                return
                
            }
            let userMessage = self.messageInputField.text!
            VirgilClient.shared.prepareUser("User11", completion: {() in
                
                let eMessage = VirgilClient.shared.encrypt(userMessage, for: "User11")
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
