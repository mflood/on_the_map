//
//  OtmTabBarController.swift
//  On The Map
//
//  Created by Matthew Flood on 3/4/23.
//

import Foundation
import UIKit

class OtmTabBarController: UITabBarController {

    var udacitySessionResponse: UdacitySessionResponse!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loadStudentLocations()
        
        self.navigationItem.title = "On The Smap"
        
        let logoutButton = UIBarButtonItem(title: "Logout", image: nil, target: self, action: #selector(logoutTapped))
        self.navigationItem.leftBarButtonItem = logoutButton
        
    }
    
    @objc func logoutTapped() {
        self.navigateToLoginScreen()
    }

    
    func navigateToLoginScreen() {

        let otmTabBarController = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        otmTabBarController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(otmTabBarController, animated: true)
    }

    func loadStudentLocations() {
        getStudentLocations(callback: handleGetAnnotations)
    }
    
    func handleGetAnnotations(studentLocations: [StudentLocation]?, _ error: String?) {
        
        guard let studentLocations = studentLocations else {
            return
        }
        
        DispatchQueue.main.async {
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            appDelegate.studentLocations = studentLocations
        }
    }
    
}


