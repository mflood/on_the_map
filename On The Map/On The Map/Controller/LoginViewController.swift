//
//  ViewController.swift
//  On The Map
//
//  Created by Matthew Flood on 3/4/23.
//

import UIKit

let DEBUG_SKIP_LOGIN: Bool = false

class LoginViewController: UIViewController {

    
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var SignUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func handleLoginButtonClicked(_ sender: Any) {
        
        guard let emailText = emailTextfield.text,
            emailText != ""  else {
            showAlert(title: "Login Failed", message: "Provide a username")
            return
        }
        
        guard let passwordText = passwordTextfield.text,
            passwordText != ""  else {
            showAlert(title: "Login Failed", message: "Provide a password")
            return
        }
        
        let udacitySessionRequest = UdacitySessionRequest(udacity: UdacityUser(username: emailText, password: passwordText))
        
        getUdacitySession(udacitySessionRequest: udacitySessionRequest, callback: handleUdacitySessionResponse)
    }
    
    func handleUdacitySessionResponse(udacitySessionResponse: UdacitySessionResponse?, error: String?) {
        
        if DEBUG_SKIP_LOGIN {
            getPublicStudentInformation(userId: "3903878747")
            return
        }
        
        if let error = error {
            DispatchQueue.main.async {
                self.showAlert(title: "Login Failed", message: error)
            }
        } else if let udacitySessionResponse = udacitySessionResponse {
            getPublicStudentInformation(userId: udacitySessionResponse.account.key)
        } else {
            showAlert(title: "Login Failed", message: "Unknown error.")
        }
    }
    
    func getPublicStudentInformation(userId: String) {
        UdacityApiClient.getPublicUserData(userId: userId, callback: self.handleGetPublicStudentInformationResponse)
    }
    
    func handleGetPublicStudentInformationResponse(_ errorString: String?) {
        if let error = errorString {
            DispatchQueue.main.async { //
                self.showAlert(title: "Getting user information failed", message: error)
            }
        } else {
            navigateToMainApp()
        }
    }
    
    func navigateToMainApp() {
        DispatchQueue.main.async {
            self.passwordTextfield.text = ""
            let otmTabBarController = self.storyboard!.instantiateViewController(withIdentifier: "OtmRootNavigationController") as! UINavigationController
            
            otmTabBarController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.present(otmTabBarController, animated: true)
        }
    }
    
    @IBAction func handleEditingDidEnd(_ sender: Any) {
        if let textfield = sender as? UITextField {
            textfield.resignFirstResponder()
        }
    }
    
    @IBAction func handleSignUpButtonClicked(_ sender: Any) {
        
        let signupUrl = "https://www.udacity.com/account/auth#!/signup"
        
        guard let url = URL(string: signupUrl) else {
                       return
               }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        // Add an "OK" button to the alert controller
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: .default,
                                                handler: nil))
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }

}

