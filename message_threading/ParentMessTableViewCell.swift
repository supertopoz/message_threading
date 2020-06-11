//
//  ParentMessTableViewCell.swift
//  message_threading
//
//  Created by Jason.Allshorn on 2020/06/04.
//  Copyright © 2020 Jason.Allshorn. All rights reserved.
//

import UIKit

class ParentMessTableViewCell: UITableViewCell {

    @IBOutlet weak var messageIdLabel: UILabel!
    @IBOutlet weak var messageMessageLabel: UILabel!
    @IBOutlet weak var messageHolderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        messageHolderView.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
