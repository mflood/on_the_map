//
//  StudentLocation.swift
//  On The Map
//
//  Created by Matthew Flood on 3/4/23.
//

import Foundation

class StudentLocation: Codable {
    var objectId: String    // uniquely identifies a StudentLocation (ZExGR5uX8)
    var uniqueKey: String?  // populate this value using your Udacity account id (1234)
    var firstName: String
    var lastName: String
    var mapString: String   // (Mountain View, CA)
    var mediaURL: String    // the URL provided by the student (https://udacity.com)
    var latitude: Int       // ranges from -90 to 90 (37.386052)
    var longitude: Int      // ranges from -180 to 180 (-122.083851)
    var createdAt: String
    var updatedAt: String
    var ACL: String // the Parse access and control list (Public Read and Write)
    
    

}