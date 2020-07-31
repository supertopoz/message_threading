//
//  OtherUsersView.swift
//  message_threading
//
//  Created by Jason.Allshorn on 2020/07/24.
//  Copyright © 2020 Jason.Allshorn. All rights reserved.
//

import UIKit

class OtherUsersReplyMessageView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var messageHolderView: UIView!
    @IBOutlet weak var message: UILabel!
  
    
    @IBOutlet weak var sentTimestampLabel: UILabel!
    @IBOutlet weak var repliedMessageContainerView: UIView!
    @IBOutlet weak var messageBackgroundView: UIView!
    @IBOutlet weak var restrictedWidthHolderView: UIView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        self.messageHolderView.layer.cornerRadius = 10
        self.messageBackgroundView.layer.cornerRadius = 10
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("OtherUsersReplyMessageView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
