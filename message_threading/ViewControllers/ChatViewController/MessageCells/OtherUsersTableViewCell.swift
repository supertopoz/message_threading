//
//  ParentMessTableViewCell.swift
//  message_threading
//
//  Created by Jason.Allshorn on 2020/06/16.
//  Copyright © 2020 Jason.Allshorn. All rights reserved.
//

import UIKit

class OtherUsersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageViewHolder: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.messageViewHolder.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
