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
        
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshTapped))
        self.navigationItem.rightBarButtonItem = refreshButton

    }
    
    @objc func logoutTapped() {
        self.navigateToLoginScreen()
    }

    @objc func refreshTapped() {
        self.loadStudentLocations()
    }
    
    func navigateToLoginScreen() {
        let otmTabBarController = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        otmTabBarController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(otmTabBarController, animated: true)
    }

    func loadStudentLocations() {
        getStudentLocations(callback: handleGetAnnotations)
    }
    
    func handleGetAnnotations(studentLocations: [StudentInformation]?, _ error: String?) {
        
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


