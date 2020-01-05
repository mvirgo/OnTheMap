//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Michael Virgo on 12/15/19.
//  Copyright © 2019 mvirgo. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    // MARK: IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: View functions
    override func viewWillAppear(_ animated: Bool) {
        mapView.delegate = self
        // Create array to hold pin annotations
        var annotations = [MKPointAnnotation]()
        
        // Create an annotation for each student location
        for location in LocationModel.locations {
            // Get latitude and longitude
            let lat = CLLocationDegrees(Float(location.latitude))
            let long = CLLocationDegrees(Float(location.longitude))
            
            // Create a map point from lat and long
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            // Create the annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = location.firstName + " " + location.lastName
            annotation.subtitle = location.mediaURL
            
            // Append to the full array
            annotations.append(annotation)
        }
        
        // Add the annotations to the map
        self.mapView.addAnnotations(annotations)
        
        super.viewWillAppear(animated)
    }
    
    // MARK: Map view functions
    // Below function based on Udacity PinSample code - pin style
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // Below function based on Udacity PinSample code - open mediaURL on click
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!)
            }
        }
    }
}
