//
//  File.swift
//  message_threading
//
//  Created by Jason.Allshorn on 2020/07/24.
//  Copyright © 2020 Jason.Allshorn. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func roundCorners(view :UIView, corners: UIRectCorner, radius: CGFloat){
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
    }
}

struct GetMessageTimestamp {
    let timestamp: String
    init(from timestamp: Int64){
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss"
        self.timestamp = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(timestamp/1000)))
    }
    func showTime() -> String {
        return self.timestamp
    }
}
