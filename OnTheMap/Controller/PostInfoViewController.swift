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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // If Find Location button tapped, check the location and URL
    // TODO: Send info to the individual map view if valid
    @IBAction func findLocationTapped(_ sender: Any) {
        var valid_inputs = true
        // Check the location
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationLabel.text!) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!.coordinate
                    print(location)
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
            // Only segue if both inputs are valid
            if valid_inputs {
                self.performSegue(withIdentifier: "findLocation", sender: nil)
            }
        }
    }
    
    // Return to the tabbed view
    @IBAction func goBack(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    func alertUser(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.navigationController?.present(alertVC, animated: true, completion: nil)
    }
}
