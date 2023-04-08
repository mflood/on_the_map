//
//  ViewController.swift
//  On The Map
//
//  Created by Matthew Flood on 3/4/23.
//

import UIKit

let DEBUG_SKIP_LOGIN: Bool = true

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
        
        guard let emailText = self.emailTextfield.text,
            emailText != ""  else {
            showAlert(title: "Login Failed", message: "Provide a username")
            return
        }
        
        guard let passwordText = self.passwordTextfield.text,
              passwordText != ""  else {
            showAlert(title: "Login Failed", message: "Provide a password")
            return
        }
        
        let udacitySessionRequest = UdacitySessionRequest(udacity: UdacityUser(username: emailText, password: passwordText))
        
        getUdacitySession(udacitySessionRequest: udacitySessionRequest, callback: handleUdacitySessionResponse)
    }
    
    func handleUdacitySessionResponse(udacitySessionResponse: UdacitySessionResponse?, error: String?) {
        
        if DEBUG_SKIP_LOGIN {
            let fakeResponse = UdacitySessionResponse(account: UdacityAccount(registered: true, key: "04305036399"),
                                                      session: UdacitySession(id: "7740545436S0b45310ec01d724572bce219437a2231", expiration: "2023-04-04T00:24:08.238983Z"))
            navigateToMainApp(udacitySessionResponse: fakeResponse)
            return
        }
        
        if let error = error {
            DispatchQueue.main.async { // IfKU4D%t2@TBE&q&
                self.showAlert(title: "Login Failed", message: error)
            }
        } else if let udacitySessionResponse = udacitySessionResponse {
            navigateToMainApp(udacitySessionResponse: udacitySessionResponse)
        } else {
            showAlert(title: "Login Failed", message: "Unknown error.")
        }
    }
    
    func navigateToMainApp(udacitySessionResponse: UdacitySessionResponse) {
        DispatchQueue.main.async {
            self.passwordTextfield.text = ""
            let otmTabBarController = self.storyboard!.instantiateViewController(withIdentifier: "OtmRootNavigationController") as! OtmRootNavigationController
            
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
    
    @IBAction func testMapApi(_ sender: Any) {
       
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

