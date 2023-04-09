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
    var pinAnnotation: MKPointAnnotation?
    var pinCoordinate: CLLocationCoordinate2D!
    var url: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        self.addPinToMap(coordinate: self.pinCoordinate)
        self.centerMap(coordinate: self.pinCoordinate)
        
    }
    
    @IBAction func handleFinishButtonClicked(_ sender: Any) {
        print(sender)
    }
    
    func addPinToMap(coordinate: CLLocationCoordinate2D) {
        let newPin = MKPointAnnotation()
        newPin.coordinate = coordinate
        mapView.addAnnotation(newPin)
        pinAnnotation = newPin
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
