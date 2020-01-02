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
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
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
}
