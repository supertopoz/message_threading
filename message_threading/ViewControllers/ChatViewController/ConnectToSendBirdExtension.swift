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
    
    func initVirgil() {
        
    }
    
    func initConnections(){
        SBDMain.connect(withUserId: "Alice", completionHandler: { (user, error) in
            guard error == nil else {
                self.showToast("Failed to connect: \(String(describing: error?.localizedDescription))")
                return
                
            }
            self.showToast("Connected to Sendbird")
            
            Account.shared.login("Alice", completion: {(result, error) in
                guard error == nil else {
                    print(error?.localizedDescription)
                    return
                }
                print(result)
            })

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
