//
//  StudentLocation.swift
//  On The Map
//
//  Created by Matthew Flood on 3/4/23.
//

import Foundation

// This is all random

struct AddStudentInformationRequest: Codable {
    
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String   // (Mountain View, CA)
    var mediaUrl: String    // the URL provided by the student (https://udacity.com)
    var latitude: Float       // ranges from -90 to 90 (37.386052)
    var longitude: Float      // ranges from -180 to 180 (-122.083851)
    
    enum CodingKeys: String, CodingKey {
        case uniqueKey
        case firstName
        case lastName
        case mapString
        case mediaUrl = "mediaURL"
        case latitude
        case longitude
    }
}

struct PostStudentInformationResponse: Codable {
    var objectId: String
    var createdAt: String
}

struct StudentInformation: Codable {
    
    var objectId: String    // uniquely identifies a StudentLocation (ZExGR5uX8)
    var uniqueKey: String?  // populate this value using your Udacity account id (1234)
    var firstName: String
    var lastName: String
    var mapString: String   // (Mountain View, CA)
    var mediaUrl: String    // the URL provided by the student (https://udacity.com)
    var latitude: Float       // ranges from -90 to 90 (37.386052)
    var longitude: Float      // ranges from -180 to 180 (-122.083851)
    var createdAt: String
    var updatedAt: String
    var Acl: String? // the Parse access and control list (Public Read and Write)
    
    
    enum CodingKeys: String, CodingKey {
        case objectId
        case uniqueKey
        case firstName
        case lastName
        case mapString
        case mediaUrl = "mediaURL"
        case latitude
        case longitude
        case createdAt
        case updatedAt
        case Acl = "ACL"
    }
}

class StudentLocationResponse: Codable {
        
    var results: [StudentInformation]
}

class StudentsData: NSObject {

    var students = [StudentInformation]()

    class func sharedInstance() -> StudentsData {
        struct Singleton {
            static var sharedInstance = StudentsData()
        }
        return Singleton.sharedInstance
    }

}
