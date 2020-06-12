//
//  ConnectToSendBirdExtension.swift
//  message_threading
//
//  Created by Jason.Allshorn on 2020/06/12.
//  Copyright © 2020 Jason.Allshorn. All rights reserved.
//

import Foundation
import SendBirdSDK

extension ChatViewController {
    
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
