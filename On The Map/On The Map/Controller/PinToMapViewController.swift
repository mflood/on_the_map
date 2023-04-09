//
//  PinToMapViewController.swift
//  On The Map
//
//  Created by Matthew Flood on 4/9/23.
//

import Foundation
import UIKit
import MapKit

class PinToMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    // var pinAnnotation: MKPointAnnotation?
    
    // Set these before presenting view
    var pinCoordinate: CLLocationCoordinate2D!
    var mapString: String!
    var url: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        self.addPinToMap(coordinate: self.pinCoordinate)
        self.centerMap(coordinate: self.pinCoordinate)
        
    }
    
    @IBAction func handleFinishButtonClicked(_ sender: Any) {


        let newRequest = AddStudentInformationRequest(mapString: self.mapString,
                                                      mediaUrl: self.url,
                                                      latitude: Float(self.pinCoordinate.latitude),
                                                      longitude: Float(self.pinCoordinate.longitude)
        )
        postStudentLocation(addStudentInformationRequest: newRequest, callback: self.handlePostStudentLocationResponse)
    }
    
    
    func handlePostStudentLocationResponse(error: String?) {
        
        if let error = error {
            let alertController = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)

            // Add an action to the alert
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                // Handle the OK action
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            navigateToMainTabView()
        }
    }
    
    func navigateToMainTabView() {
        DispatchQueue.main.async {
            let otmTabBarController = self.storyboard!.instantiateViewController(withIdentifier: "OtmRootNavigationController") as! OtmRootNavigationController
            
            otmTabBarController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            // self.navigationController?.present(<#T##viewControllerToPresent: UIViewController##UIViewController#>, animated: <#T##Bool#>)
            self.present(otmTabBarController, animated: true)
        }
    }
    
    func addPinToMap(coordinate: CLLocationCoordinate2D) {
        let newPin = MKPointAnnotation()
        newPin.coordinate = coordinate
        mapView.addAnnotation(newPin)
        // pinAnnotation = newPin
    }
    
    func centerMap(coordinate: CLLocationCoordinate2D) {
        self.mapView.centerCoordinate = coordinate
    }
    
    // Map view delegate method to allow the user to drag the pin around
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let pinAnnotation = annotation as? MKPointAnnotation {
            let pinView = MKMarkerAnnotationView(annotation: pinAnnotation, reuseIdentifier: "pin")
            pinView.isDraggable = true
            return pinView
        }
        return nil
    }
    
    // Capture the final coordinate
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == .ending {
            self.pinCoordinate = view.annotation?.coordinate
            print("New pin Location: \(self.pinCoordinate?.latitude ?? 0), \(self.pinCoordinate?.longitude ?? 0)")
        }
    }
}
