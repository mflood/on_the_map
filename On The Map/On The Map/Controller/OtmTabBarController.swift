//
//  OtmTabBarController.swift
//  On The Map
//
//  Created by Matthew Flood on 3/4/23.
//

import Foundation
import UIKit

class OtmTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loadStudentLocations()
    }

    func loadStudentLocations() {
        getStudentLocations(callback: handleGetAnnotations)
    }
    
    func handleGetAnnotations(studentLocations: [StudentLocation]?, _ error: String?) {
        
        guard let studentLocations = studentLocations else {
            return
        }
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.studentLocations = studentLocations
    }
    
}


