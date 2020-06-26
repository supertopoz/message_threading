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
    
    public func prepareUsers(with users: [String], completion: @escaping (Error?) -> Void) {
        guard self.eThree != nil else  {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "No encryption service available"])
            completion(error)
            return
        }
        eThree!.findUsers(with: users) { [weak self] result, _ in
            self?.userCards = result!
            completion(nil)
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
        eThree?.rotatePrivateKey { error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            completion("Private key removed and re-issued", nil)
        }
    }
    
    public func decrypt(_ text: String) -> String {
        guard self.eThree != nil else { return "No encryption tools available" }
        do {
            let text = try eThree!.authDecrypt(text: text)
            return text
        } catch {
            return "Could not decrpyt message: \(error.localizedDescription)"  
        }
    }
    
    public func encrypt(_ text: String, for user: String) -> String {
        guard self.eThree != nil else { return "No encryption tools available" }
        do {
            let text = try eThree!.authEncrypt(text: text, for: userCards[user]!)
            return text
        } catch {
            return error.localizedDescription
        }
    }
}
