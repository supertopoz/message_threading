//
//  MyMessagesTableViewCell.swift
//  message_threading
//
//  Created by Jason.Allshorn on 2020/06/16.
//  Copyright © 2020 Jason.Allshorn. All rights reserved.
//

import UIKit

class MyMessagesTableViewCell: UITableViewCell {

    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageHolderView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.messageHolderView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
