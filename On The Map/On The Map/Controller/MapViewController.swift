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

    var studentLocations: [StudentLocation]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.studentLocations
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loadStudentLocations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let stu = self.studentLocations
        print("Map view appearing: \(stu?.count) studentLocations")
    }
    

    
    
    func loadStudentLocations() {
        getStudentLocations(callback: handleGetAnnotations)
    }
    
    func handleGetAnnotations(studentLocations: [StudentLocation]?, _ error: String?) {
        
        guard let studentLocations = studentLocations else {
            return
        }
        
        let annotations = self.makeAnnotations(studentLocations: studentLocations)
        
        DispatchQueue.main.async {
            self.mapView.addAnnotations(annotations)
        }
    }
    
    func makeAnnotations(studentLocations: [StudentLocation]) -> [MKPointAnnotation] {
        
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
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        return annotations
    }

    
    
}

