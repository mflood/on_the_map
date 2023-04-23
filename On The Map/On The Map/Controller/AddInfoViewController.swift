//
//  AddInfoViewController.swift
//  On The Map
//
//  Created by Matthew Flood on 4/9/23.
//

import Foundation
import UIKit
import CoreLocation

class AddInfoViewController: UIViewController {
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let logoutButton = UIBarButtonItem(title: "Cancel", image: nil, target: self, action: #selector(cancelTapped))
        navigationItem.leftBarButtonItem = logoutButton
    }
    
    @IBAction func handleFindButtonClicked(_ sender: Any) {
        
        if let address = addressTextField.text {
            geocodeAddress(address: address)
        }
    }
    
    @IBAction func handleEditingDidEnd(_ sender: Any) {
        if let textfield = sender as? UITextField {
            textfield.resignFirstResponder()
        }
    }
    
    @objc func cancelTapped() {
        navigateToMainTabView()
    }
    
    
    func navigateToMainTabView() {
        DispatchQueue.main.async {
            let otmTabBarController = self.storyboard!.instantiateViewController(withIdentifier: "OtmRootNavigationController") as! UINavigationController
            
            otmTabBarController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.present(otmTabBarController, animated: true)
        }
    }

    func geocodeAddress(address: String) {
        let geocoder = CLGeocoder()
        // let address = "1600 Amphitheatre Parkway, Mountain View, CA"
        geocoder.geocodeAddressString(address) { [self] (placemarks, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self.showGeocodeError(error: error.localizedDescription )
                }
                return
            }
            guard let placemark = placemarks?.first else {
                DispatchQueue.main.async {
                    self.showGeocodeError(error: "Could not find a place matching that address")
                }
                return
            }
            print("Latitude: \(placemark.location?.coordinate.latitude ?? 0.0)")
            print("Longitude: \(placemark.location?.coordinate.longitude ?? 0.0)")
            DispatchQueue.main.async {
                if let location = placemark.location {
                    self.navigateToPinToMap(coordinate: location.coordinate)
                }
            }
        }
    }
    
    func navigateToPinToMap(coordinate: CLLocationCoordinate2D) {
        let pinToMapViewController = storyboard!.instantiateViewController(withIdentifier: "PinToMapViewController") as! PinToMapViewController
        
        pinToMapViewController.pinCoordinate = coordinate
        pinToMapViewController.url = urlTextField.text ?? ""
        pinToMapViewController.mapString = addressTextField.text ?? ""
        
       // otmTabBarController.modalPresentationStyle = //UIModalPresentationStyle.fullScreen
        navigationController?.show(pinToMapViewController, sender: self)
    }
    
    func showGeocodeError(error: String) {
        let alertController = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)

        // Add an action to the alert
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Handle the OK action
        }
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
   

    
}
