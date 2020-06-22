//
//  Account.swift
//  message_threading
//
//  Created by Jason.Allshorn on 2020/06/22.
//  Copyright © 2020 Jason.Allshorn. All rights reserved.
//

import Foundation
import Alamofire

class Account {
    public static let shared = Account()

    let apiRoot = "http://127.0.0.1:3000"
    var authToken: String? = nil
    var userId: String? = nil

    public func login(_ userId: String, completion: @escaping (String?, Error?) -> Void) {
        AF
            .request("\(apiRoot)/authenticate",
                     method: .post,
                     parameters: ["identity" : userId],
                     encoder: JSONParameterEncoder.default)
            .responseJSON { response in
                let body = response.value as! NSDictionary
                let authToken = body["authToken"]! as! String
                self.authToken = authToken
                self.userId = userId
                self.setupVirgil(completion)
        }
    }
    
    private func setupVirgil(_ completion: @escaping (String?, Error?) -> Void) {
        AF
            .request("\(apiRoot)/virgil-jwt",
                      method: .get,
                      headers: ["Authorization" : "Bearer \(authToken!)"])
            .responseJSON { response in
                let body = response.value as! NSDictionary
                let token = body["virgilToken"]! as! String
                VirgilClient.configure(identity: self.userId!, token: token, completion: {(result, error) in
                    guard error == nil else {
                        completion(nil, error)
                        return
                    }
                    completion(result, nil)
                })
        }
    }
}
