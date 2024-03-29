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
        addPinToMap(coordinate: pinCoordinate)
        centerAndZoomMap(coordinate: pinCoordinate)
    }
    
    @IBAction func handleFinishButtonClicked(_ sender: Any) {

        DispatchQueue.main.async { [self] in
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            if let accountId = appDelegate.udacitySessionResponse?.account.key,
               let publicUserData = appDelegate.publicUserData {
                
                let newRequest = AddStudentInformationRequest(uniqueKey: accountId,
                                                              firstName: publicUserData.firstName,
                                                              lastName: publicUserData.lastName,
                                                              mapString: self.mapString,
                                                              mediaUrl: self.url,
                                                              latitude: Float(pinCoordinate.latitude),
                                                              longitude: Float(pinCoordinate.longitude)
                )
                
                if let objectId = appDelegate.myLocationObjectId {
                    // update existing...
                    OnTheMapApiClient.putStudentLocation(objectId: objectId, addStudentInformationRequest: newRequest, callback: self.handleUpdateStudentLocationResponse)
                    
                } else {
                    // create new
                    OnTheMapApiClient.postStudentLocation(addStudentInformationRequest: newRequest, callback: self.handlePostStudentLocationResponse)
                }
                
            }

        }
        
    }
    
    func handleUpdateStudentLocationResponse(error: String?) {
        DispatchQueue.main.async {
            
            if let error = error {
                let alertController = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
                
                // Add an action to the alert
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    // Handle the OK action
                }
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                self.navigateToMainTabView()
            }
        }
    }
    
    // This is the callback invoked by the api after we post a new
    // StudentInformation.
    func handlePostStudentLocationResponse(objectId: String?, error: String?) {
        
        // Store the new objectId on the App Delegate
        // if a value is set there, then we will use
        // the "update" endpoint instead of the "new" endpoint
        DispatchQueue.main.async {
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            appDelegate.myLocationObjectId = objectId
        
            if let error = error {
                let alertController = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)

                // Add an action to the alert
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    // nothing to do for the okay action...
                }
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                self.navigateToMainTabView()
            }
        }
    }
    
    func navigateToMainTabView() {
        self.dismiss(animated: true)
    }
    
    // Add a single empty pin to the map at the given location
    func addPinToMap(coordinate: CLLocationCoordinate2D) {
        let newPin = MKPointAnnotation()
        newPin.coordinate = coordinate
        mapView.addAnnotation(newPin)
    }
    
    // adjust the map so that the coordinate is showing
    // at the center of the view
    func centerAndZoomMap(coordinate: CLLocationCoordinate2D) {
        
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(
              center: coordinate,
              latitudinalMeters: regionRadius,
              longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        
       // mapView.centerCoordinate = coordinate
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
            pinCoordinate = view.annotation?.coordinate
            debugPrint("New pin Location: \(pinCoordinate?.latitude ?? 0), \(pinCoordinate?.longitude ?? 0)")
        }
    }
}
