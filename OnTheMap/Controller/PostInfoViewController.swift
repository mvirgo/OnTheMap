//
//  PostInfoViewController.swift
//  OnTheMap
//
//  Created by Michael Virgo on 12/15/19.
//  Copyright © 2019 mvirgo. All rights reserved.
//

import UIKit
import MapKit

class PostInfoViewController: UIViewController {
    
    @IBOutlet weak var locationLabel: UITextField!
    @IBOutlet weak var profileLabel: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var foundLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // If Find Location button tapped, check the location and URL
    @IBAction func findLocationTapped(_ sender: Any) {
        var valid_inputs = true
        // Check the location
        let geocoder = CLGeocoder()
        // Animate activity indicator and disable text fields
        setGeocoding(true)
        geocoder.geocodeAddressString(locationLabel.text!) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    self.foundLocation = placemark.location!.coordinate
                }
                // Check the profile url field is not empty
                if self.profileLabel.text == "" {
                    valid_inputs = false
                    self.alertUser(title: "Invalid Link", message: "Profile Link cannot be empty.")
                }
            } else {
                valid_inputs = false
                self.alertUser(title: "Invalid Location", message: "Provided location invalid or unable to be found.")
            }
            // Hide activity indicator and enable text fields
            self.setGeocoding(false)
            // Only segue if both inputs are valid
            if valid_inputs {
                // Get the Post Info Map controller
                let mapController = self.storyboard!.instantiateViewController(withIdentifier: "postInfoMap") as! PostInfoMapViewController
                
                // Load the current meme into the Meme Editor
                mapController.locationText = self.locationLabel.text
                mapController.profileURL = self.profileLabel.text
                mapController.coordinates = self.foundLocation
                
                // Present the view controller using navigation
                self.navigationController!.pushViewController(mapController, animated: true)
            }
        }
    }
    
    // Return to the tabbed view
    @IBAction func goBack(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    func setGeocoding(_ geocoding: Bool) {
        if geocoding {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        locationLabel.isEnabled = !geocoding
        profileLabel.isEnabled = !geocoding
    }
    
    func alertUser(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.navigationController?.present(alertVC, animated: true, completion: nil)
    }
}
