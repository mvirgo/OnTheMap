//
//  PostInfoMapViewController.swift
//  OnTheMap
//
//  Created by Michael Virgo on 1/2/20.
//  Copyright © 2020 mvirgo. All rights reserved.
//

import UIKit
import MapKit

class PostInfoMapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    var locationText: String?
    var profileURL: String?
    var coordinates: CLLocationCoordinate2D?
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.delegate = self
        // Create the annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates!
        annotation.title = locationText
        // Add the annotation to the map & select it
        self.mapView.showAnnotations([annotation], animated: true)
        self.mapView.selectAnnotation(annotation, animated: true)
        
        super.viewWillAppear(animated)
    }
    
    // Below function based on Udacity PinSample code - pin style
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
}
