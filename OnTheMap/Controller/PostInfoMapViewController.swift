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
    
    // Get user data and post location when finished, then go back to Tab Bar View
    @IBAction func finishTapped(_ sender: Any) {
        // Get user's first name and last name, and post if successful
        APIClient.getUserData(completion: handleUserData(success:error:))
        // Pop back to the Tab Bar View Controller (3 above)
        let vCs = self.navigationController!.viewControllers
        self.navigationController!.popToViewController(vCs[vCs.count - 3], animated: true)
    }
    
    // Check if successfully gathered user data and post location, if so
    func handleUserData(success: Bool, error: Error?) {
        if success {
            APIClient.postLocation(mapString: locationText!, profile: profileURL!, latitude: Float(coordinates!.latitude), longitude: Float(coordinates!.longitude), completion: handlePostingLocation(success:error:))
        } else {
            alertUser(title: "User Not Found", message: "Unable to gather user data from Udacity API.")
        }
    }
    
    // Check whether successful at posting user information
    func handlePostingLocation(success: Bool, error: Error?) {
        if success {
            print("Successfully posted location.")
        } else {
            alertUser(title: "Failed to Post Location", message: "Unable to post your location to the On the Map API.")
        }
    }
    
    // Alert the user if getting data or posting location failed
    func alertUser(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.navigationController?.present(alertVC, animated: true, completion: nil)
    }
}
