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
            let channelUrl = "sendbird_group_channel_127670705_1807adade5874514d3669a18bcf14efc6db67850"
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
