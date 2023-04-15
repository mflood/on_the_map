//
//  UdacitySchema.swift
//  On The Map
//
//  Created by Matthew Flood on 4/2/23.
//

import Foundation


struct UdacityUser: Codable {
    var username: String
    var password: String
}

struct UdacitySessionRequest: Codable {

    var udacity: UdacityUser
    
    func toJsonData() -> Data? {
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(self)
            return jsonData
            //let jsonString = String(data: jsonData, encoding: .utf8)
            //return jsonString
        } catch {
            return nil
        }
    }
}

struct UdacityAccount: Codable {
    var registered: Bool
    var key: String
}

struct UdacitySession: Codable {
    var id: String
    var expiration: String
}

struct UdacitySessionResponse: Codable {
    var account: UdacityAccount
    var session: UdacitySession
}

struct UdacityErrorResponse: Codable {
    var status: Int32
    var error: String
}
