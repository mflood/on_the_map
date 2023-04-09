//
//  OnTheMapApiClient.swift
//  On The Map
//
//  Created by Matthew Flood on 3/4/23.
//

import Foundation
import UIKit

class OnTheMapApiClient {
    
    enum Endpoint {
        
        case newestLocations
        case postNewLocation
        
        var stringValue: String {
            switch self {
                
            case .newestLocations:
                return "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt"
            case .postNewLocation:
                return "https://onthemap-api.udacity.com/v1/StudentLocation"
            }
        }
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
    }
}

func postStudentLocation(addStudentInformationRequest: AddStudentInformationRequest, callback: @escaping (_ error: String?) -> Void) {
    
    let encoder = JSONEncoder()
    guard let jsonData = try? encoder.encode(addStudentInformationRequest) else {
        callback("Could not convert request to json")
        return
    }

    var request = URLRequest(url: OnTheMapApiClient.Endpoint.postNewLocation.url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
//    request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: .utf8)
    
    request.httpBody = jsonData
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
        if error != nil { // Handle error…
            callback(error!.localizedDescription)
        }
        print(String(data: data!, encoding: .utf8)!)
        callback(nil)
        
    }
    task.resume()
    
    
}

func getStudentLocations(callback: @escaping (_ studentLocations: [StudentInformation]?, _ error: String?) -> Void) {
    
    let request = URLRequest(url: OnTheMapApiClient.Endpoint.newestLocations.url)
    let session = URLSession.shared
    
    let task = session.dataTask(with: request) { data, response, error in
        if error != nil { // Handle error...
            callback(nil, error?.localizedDescription)
            return
        }
        guard let data = data else {
            callback(nil, error?.localizedDescription)
            return
        }
        // print(String(data: data, encoding: .utf8)!)
        
        let decoder = JSONDecoder()
        var response: StudentLocationResponse

        do {
            response = try decoder.decode(StudentLocationResponse.self, from: data)
            callback(response.results, nil)
        } catch {
            callback(nil, "\(error)")
        }
    }
    task.resume()
}
