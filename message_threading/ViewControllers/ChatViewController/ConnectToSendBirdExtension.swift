//
//  ConnectToSendBirdExtension.swift
//  message_threading
//
//  Created by Jason.Allshorn on 2020/06/12.
//  Copyright © 2020 Jason.Allshorn. All rights reserved.
//

import Foundation
import SendBirdSDK
import VirgilE3Kit

extension ChatViewController {
    
    func connectToSendbird(){
        SBDMain.connect(withUserId: "User11", completionHandler: { (user, error) in
            guard error == nil else {
                self.showToast("Failed to connect: \(String(describing: error?.localizedDescription))")
                return
                
            }
            self.showToast("Connected to Sendbird")
            let virgil = Virgil()
            let currentUserId = SBDMain.getCurrentUser()?.userId
            print(currentUserId!)
            virgil.login(user:currentUserId!, jwtCallback:virgil.authWithVirgil, completion: {(result, error) in
                guard error == nil else {
                    DispatchQueue.main.async {
                        self.showToast("Virgil Says: \(error?.localizedDescription)" )
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.showToast("Virgil logged in:\(result)" ?? "Virgil logged in")
                }
                virgil.logout()
            })
            
            let message = "Hello, Alice and Den!"
            let identities = ["Alice"]
            
//            virgil.eThree.findUsers(with: identities){ findUsersResult, error in
//                guard let findUsersResult = findUsersResult, error == nil else {
//                    print("VIGIL ERROR: \(String(describing: error?.localizedDescription))")
//                    return
//                }
//                let encryptMessage = try! virgil.eThree.authEncrypt(text: message, for: findUsersResult)
//                DispatchQueue.main.async {
//                    self.showToast("Messages: \(encryptMessage)")                }
//            }
            // Search user's Cards to encrypt for
//            ethree!.findUsers(with: identities) { findUsersResult, error in
//                guard let findUsersResult = findUsersResult, error == nil else {
//                    // Error handling here
//                }
//
//                // encrypt text
//                let encryptedMessage = try! eThree.authEncrypt(text: messageToEncrypt, for: findUsersResult)
//            }
            let channelUrl = "sendbird_group_channel_127670705_1807adade5874514d3669a18bcf14efc6db67850"
            SBDGroupChannel.getWithUrl(channelUrl) { (channel, error) in
                guard error == nil else {
                    self.showToast("Failed to fetch channel: \(String(describing: error?.localizedDescription))")
                    return
                }
                self.currentChannel = channel
            }
        })
    }
    
}
