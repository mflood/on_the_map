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
        fetchStudentInformation()
        
        navigationItem.title = "On The Smap"
        
        let logoutButton = UIBarButtonItem(title: "Logout", image: nil, target: self, action: #selector(logoutTapped))
        navigationItem.leftBarButtonItem = logoutButton
        
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshTapped))
        
        let addNewItemButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItemTapped))
        navigationItem.rightBarButtonItems = [refreshButton, addNewItemButton]
    }
    
    
    
    @objc func logoutTapped() {
        deleteUdacitySession()
        navigateToLoginScreen()
    }

    @objc func refreshTapped() {
        fetchStudentInformation()
    }
    
    @objc func addNewItemTapped() {
       navigateToAddInfoView()
    }
    
    func navigateToAddInfoView() {
        let addLocationController = storyboard!.instantiateViewController(withIdentifier: "AddLocationView") as! UINavigationController
        addLocationController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        present(addLocationController, animated: true)
    }
    
    func navigateToLoginScreen() {
        self.dismiss(animated: true)
    }

    func updateUiForDataLoad(isLoading: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = !isLoading
        
    }
    
    func fetchStudentInformation() {
        updateUiForDataLoad(isLoading: true)
        OnTheMapApiClient.getStudentLocations(callback: handleStudentInformationResponse)
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
            StudentsData.sharedInstance().students = studentInformation
            self.updateUiForDataLoad(isLoading: false)
        }
        
        NotificationCenter.default.post(name: studentInformationResponseSuccessNotification,
                                        object: nil, userInfo: nil)

        
    }
    
    func dismiss(animated flag: Bool) {
        // Login View is not in the Navigation Controller,
        // so we replace instead of dimiss
        let otmTabBarController = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        otmTabBarController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(otmTabBarController, animated: flag)
    }
}


