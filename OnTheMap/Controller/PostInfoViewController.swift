//
//  PostInfoViewController.swift
//  OnTheMap
//
//  Created by Michael Virgo on 12/15/19.
//  Copyright © 2019 mvirgo. All rights reserved.
//

import UIKit

class PostInfoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // TODO: Update the below for proper location finding
    //       Current set up is just for testing flow and UI
    @IBAction func findLocationTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "findLocation", sender: nil)
    }
    
    // Return to the tabbed view
    @IBAction func goBack(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    
}
