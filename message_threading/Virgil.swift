//
//  Virgil.swift
//  message_threading
//
//  Created by Jason.Allshorn on 2020/06/17.
//  Copyright © 2020 Jason.Allshorn. All rights reserved.
//

import Foundation
import VirgilE3Kit

struct VirgilUser: Codable {
    let identity =  "Alice"
}

struct AuthToken: Codable {
    let authToken: String
}

struct JwtToken: Codable {
    let virgilToken: String
}
class Virgil {
    
    var user = VirgilUser()
    var eThree: EThree!
    
    private func getAuthToken(completion: @escaping ((Data?, Error?) -> Void)) {
        print(self.user)
        guard let encoded = try? JSONEncoder().encode(self.user) else {
          //  completion(nil, nil)
            return
        }
        // Authenticate to vergil.
        let url = URL(string: "http://127.0.0.1:3000/authenticate")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                completion(nil, error)
                return
            }
            
            completion(data, nil)
            }.resume()
    }
    
   private func getJWTToken(authToken: Data, completion: @escaping ((String?, Error?) -> Void)){
        let str = String(decoding: authToken, as: UTF8.self)
        print(str)
        guard let authToken = try? JSONDecoder().decode(AuthToken.self, from: authToken) else {
             print("failed to decode authtoken")

             return
         }
        
        let url = URL(string: "http://127.0.0.1:3000/virgil-jwt")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        request.addValue("Bearer \(authToken.authToken)", forHTTPHeaderField: "Authorization")
        print(authToken.authToken)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                completion(nil, error)
                return
            }
            guard let authToken = try? JSONDecoder().decode(JwtToken.self, from: data) else {
                print(data)
                print("failed to decode jwt token")
                return
            }
            completion(authToken.virgilToken, nil)
            }.resume()
    }
    
    func authWithVirgil(completion: @escaping ((String?, Error?)-> Void)) {
        getAuthToken(completion: {data, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            guard let data = data else {
                completion(nil, error)
                return
            }
            self.getJWTToken(authToken: data, completion: {jwtToken, error in
                guard error == nil else {
                    completion(nil, error)
                    return
                }
                completion(jwtToken, nil)
            })
        })
    }
}
