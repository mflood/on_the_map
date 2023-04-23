//
//  MapViewController.swift
//  On The Map
//
//  Created by Matthew Flood on 3/4/23.
//
// NOTE: to zoom in the simulator, double click the map
// to zoom out, hold option and do the same

import Foundation


import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    var studentLocations: [StudentInformation]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.studentInformation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addStudentLocationsToMap()
        subscribeToNotifications()
        mapView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        addStudentLocationsToMap()
    }

    
    func subscribeToNotifications() {
        
       
        
//       let studentInformationResponseSuccessNotification = Notification.Name("StudentInformationResponseSuccess")
//     let studentInformationResponseFailureNotification = Notification.Name("StudentInformationResponseFailure")

        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(forName: studentInformationResponseSuccessNotification ,
                                               object: nil,
                                               queue: nil) { (notification) in
            DispatchQueue.main.async {
                self.addStudentLocationsToMap()
            }
        }
        
    }
    
    func addStudentLocationsToMap() {
        let annotations = makeAnnotations(studentLocations: studentLocations)
        
        // clear the current annotations
        let currentAnnotations = mapView.annotations
        mapView.removeAnnotations(currentAnnotations)
        
        mapView.addAnnotations(annotations)
    }
    
    
    // Build a list of MKPointAnnotation that will appear on the map
    func makeAnnotations(studentLocations: [StudentInformation]) -> [MKPointAnnotation] {
        
        var annotations = [MKPointAnnotation]()
        
        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.
        
        for studentLocation in studentLocations {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(studentLocation.latitude)
            let long = CLLocationDegrees(studentLocation.longitude)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(studentLocation.firstName) \(studentLocation.lastName)"
            annotation.subtitle = studentLocation.mediaUrl
            //if studentLocation.mediaUrl != "" {
            //    let pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "yellow")
            //    pinView.markerTintColor = .yellow
            //}
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        return annotations
    }
}


extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
           let identifier = "marker"
           var view: MKMarkerAnnotationView
           
           if let dequeuedView = mapView.dequeueReusableAnnotationView(
                                    withIdentifier: identifier)
                                        as? MKMarkerAnnotationView {
               dequeuedView.annotation = annotation
               view = dequeuedView
               view.markerTintColor = .green
           } else {
               view =
                   MKMarkerAnnotationView(annotation: annotation,
               reuseIdentifier: identifier)
               view.canShowCallout = true
               view.markerTintColor = .green
               view.rightCalloutAccessoryView = UIButton(type: .infoDark)
               
           }
           return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? MKPointAnnotation {
            if let urlString = annotation.subtitle,
             let url = URL(string: urlString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }

}
