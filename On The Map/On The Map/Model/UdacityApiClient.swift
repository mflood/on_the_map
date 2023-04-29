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
        case logout
        case getPublicUserData(userId: String)
        case getPublicUserDataFix(userId: String)
        
        var stringValue: String {
            switch self {
                
            case .login:
                // POST for login
                return "https://onthemap-api.udacity.com/v1/session"
                
            case .logout:
                // DELETE for logout
                return "https://onthemap-api.udacity.com/v1/session"
                
                
            case let .getPublicUserData(userId):
                return "https://onthemap-api.udacity.com/v1/users/\(userId)"
            case let .getPublicUserDataFix(_):
                return "https://video.udacity-data.com/topher/2016/June/575840d1_get-user-data/get-user-data.json"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func getPublicUserData(userId: String, callback: @escaping (_ errorString: String?) -> Void) {
        
        let request = URLRequest(url: UdacityApiClient.Endpoint.getPublicUserDataFix(userId: userId).url)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                callback(error?.localizedDescription)
                return
            }
            guard let data = data else {
                callback(error?.localizedDescription)
                return
            }

            let decoder = JSONDecoder()
            var response: PublicUserDataResponse

            do {
                response = try decoder.decode(PublicUserDataResponse.self, from: data)
                
                DispatchQueue.main.async {
                    let object = UIApplication.shared.delegate
                    let appDelegate = object as! AppDelegate
                    appDelegate.publicUserData = response.user
                    callback(nil)
                }
                
            } catch {
                callback("\(error)")
            }
        }
        task.resume()
        
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
            
            DispatchQueue.main.async {
                let object = UIApplication.shared.delegate
                let appDelegate = object as! AppDelegate
                appDelegate.udacitySessionResponse = response
            }
            
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


func deleteUdacitySession() {
    
    var request = URLRequest(url: UdacityApiClient.Endpoint.logout.url)
    request.httpMethod = "DELETE"
    var xsrfCookie: HTTPCookie? = nil
    let sharedCookieStorage = HTTPCookieStorage.shared
    for cookie in sharedCookieStorage.cookies! {
        if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
    }
    if let xsrfCookie = xsrfCookie {
        request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
    }
    let session = URLSession.shared
    
    let task = session.dataTask(with: request) { data, response, error in
        if error != nil { // Handle error…
            return
        }
        
        guard let data = data, error == nil else {
            return
        }
        
        let newData = data.dropFirst(5)
        print(String(data: newData, encoding: .utf8)!)
        
        DispatchQueue.main.async {
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            appDelegate.udacitySessionResponse = nil
        }
    
    }
    
    task.resume()
}
