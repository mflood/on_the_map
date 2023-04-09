//
//  OtmTabBarController.swift
//  On The Map
//
//  Created by Matthew Flood on 3/4/23.
//

import Foundation
import UIKit

let studentInformationResponseSuccessNotification = Notification.Name("StudentInformationResponseSuccess")
let studentInformationResponseFailureNotification = Notification.Name("StudentInformationResponseFailure")

class OtmTabBarController: UITabBarController {

    // var udacitySessionResponse: UdacitySessionResponse!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.fetchStudentInformation()
        
        self.navigationItem.title = "On The Smap"
        
        let logoutButton = UIBarButtonItem(title: "Logout", image: nil, target: self, action: #selector(logoutTapped))
        self.navigationItem.leftBarButtonItem = logoutButton
        
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshTapped))
        // self.navigationItem.rightBarButtonItem = refreshButton
        
        let addNewItemButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItemTapped))
        self.navigationItem.rightBarButtonItems = [refreshButton, addNewItemButton]
    }
    
    
    
    @objc func logoutTapped() {
        deleteUdacitySession()
        self.navigateToLoginScreen()
    }

    @objc func refreshTapped() {
        self.fetchStudentInformation()
    }
    
    
    @objc func addNewItemTapped() {
       //
    }
    
    func navigateToLoginScreen() {
        let otmTabBarController = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        otmTabBarController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(otmTabBarController, animated: true)
    }

    func updateUiForDataLoad(isLoading: Bool) {
        self.navigationItem.rightBarButtonItem?.isEnabled = !isLoading
        
    }
    
    func fetchStudentInformation() {
        updateUiForDataLoad(isLoading: true)
        getStudentLocations(callback: handleStudentInformationResponse)
    }
    
    func handleStudentInformationResponse(studentInformationList: [StudentInformation]?, _ errorString: String?) {
        
        guard let studentInformation = studentInformationList else {
            
            let alertController = UIAlertController(title: "Alert", message: errorString ?? "unknown error", preferredStyle: .alert)

            // Add an action to the alert
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                // Handle the OK action
            }
            
            alertController.addAction(okAction)

            DispatchQueue.main.async {
                // Present the alert
                self.present(alertController, animated: true, completion: nil)
            }
            
            
            NotificationCenter.default.post(name: studentInformationResponseFailureNotification,
                                            object: nil,
                                            userInfo: ["errorString": errorString ?? "unknown error"])
            updateUiForDataLoad(isLoading: false)
            
            DispatchQueue.main.async {
                self.updateUiForDataLoad(isLoading: false)
            }
            
            return
        }
        
        DispatchQueue.main.async {
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            appDelegate.studentInformation = studentInformation
            self.updateUiForDataLoad(isLoading: false)
        }
        
        NotificationCenter.default.post(name: studentInformationResponseSuccessNotification,
                                        object: nil, userInfo: nil)

        
    }
    
}


