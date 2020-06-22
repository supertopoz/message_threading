//
//  Virgil.swift
//  message_threading
//
//  Created by Jason.Allshorn on 2020/06/17.
//  Copyright © 2020 Jason.Allshorn. All rights reserved.
//

import Foundation
import VirgilE3Kit
import VirgilSDK

class VirgilClient {
    public static let shared = VirgilClient()
    
    private var eThree: EThree? = nil
    var userCards: [String: Card] = [:]
    
    public static func configure(identity: String, token: String, completion: @escaping (String?, Error?) -> Void ) {
        let tokenCallback: EThree.RenewJwtCallback = { completion in
            completion(token, nil)
        }
        let eThree = try! EThree(identity: identity, tokenCallback: tokenCallback)
        
        eThree.register { error in
            if let error = error {
                if error as? EThreeError == .userIsAlreadyRegistered {
                    completion(nil, error)
                } else {
                    completion(nil, error)
                }
            }
            completion("Completed registration", nil)
        }
        
        shared.eThree = eThree
    }
    
    public func prepareUser(_ user: String, completion: @escaping () -> Void) {
        eThree!.findUser(with: user) { [weak self] result, _ in
            self?.userCards[user] = result!
            completion()
        }
    }
    
    public func clearUser(completion: @escaping (String?, Error?) -> Void) {
        do {
             try eThree!.cleanUp()
             completion("User cleared", nil)
        } catch {
            completion(nil, error)
        }
    }
    
    public func rotatateUsersPrivateKey (completion: @escaping (String?, Error?) -> Void) {
        do {
            try eThree?.rotatePrivateKey { error in
                guard error == nil else {
                    completion(nil, error)
                    return
                }
                completion("Private key removed and re-issued", nil)
            }
        }
    }
    
    public func decrypt(_ text: String) -> String {
        do {
            var text = try eThree!.authDecrypt(text: text)
            return text
        } catch {
            return  error.localizedDescription
        }
    }
    
    public func encrypt(_ text: String, for user: String) -> String {
        do {
          var text = try eThree!.authEncrypt(text: text, for: userCards[user]!)
           return text
        } catch {
           return error.localizedDescription
        }
    }
}
