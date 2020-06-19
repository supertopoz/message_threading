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
    
    
    
    func initConnections(){
        SBDMain.connect(withUserId: "Alice", completionHandler: { (user, error) in
            guard error == nil else {
                self.showToast("Failed to connect: \(String(describing: error?.localizedDescription))")
                return
                
            }
            self.showToast("Connected to Sendbird")
            do {
                let params = try EThreeParams(identity: "Alice", tokenCallback: self.virgil.authWithVirgil)
                let ethree = try EThree(params: params)
                
                ethree.register { error in
                    guard error == nil else {
                        // Error handling here
                        print(error?.localizedDescription) //User is already registered
                        return
                    }
                    print("New Registration")
                    // User private key loaded, ready to end-to-end encrypt!
                }
                
            } catch {
                print(error.localizedDescription)
            }
            let channelUrl = "virgil_testing"//"sendbird_group_channel_127670705_1807adade5874514d3669a18bcf14efc6db67850"
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
