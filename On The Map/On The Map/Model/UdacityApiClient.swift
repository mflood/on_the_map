//
//  UdacityApiClient.swift
//  On The Map
//
//  Created by Matthew Flood on 4/2/23.
//

import Foundation
import UIKit

class UdacityApiClient {
    
    enum Endpoint {
        
        case login
        
        var stringValue: String {
            switch self {

            case .login:
                return "https://onthemap-api.udacity.com/v1/session"
            }
        }
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
    }
}

func getUdacitySession(udacitySessionRequest: UdacitySessionRequest, callback:  @escaping (_ udacitySessionResponse: UdacitySessionResponse?, _ error: String?) -> Void) {
    
    var request = URLRequest(url: UdacityApiClient.Endpoint.login.url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = udacitySessionRequest.toJsonData()
    
    let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
        
        guard let data = data, error == nil else {
            callback(nil, error?.localizedDescription ?? "Unknown error")
            return
        }
        
        let decoder = JSONDecoder()
        var response: UdacitySessionResponse
        
        let newData = data.dropFirst(5)
        print(String(data: data, encoding: .utf8)!)
        
        do {
            // chop off first 5 bytes... because it is junk
            response = try decoder.decode(UdacitySessionResponse.self, from: newData)
            callback(response, nil)
        } catch {
            
            var errorResponse: UdacityErrorResponse
            do {
                errorResponse = try decoder.decode(UdacityErrorResponse.self, from: newData)
                callback(nil, errorResponse.error)
            } catch {
                callback(nil, "unknown error occurred")
            }
        }
        return
    })
    task.resume()
}
