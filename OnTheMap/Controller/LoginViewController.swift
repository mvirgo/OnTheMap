//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Michael Virgo on 12/15/19.
//  Copyright © 2019 mvirgo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    // TODO: Update the below for proper login
    //       Current set up is just for testing flow and UI
    @IBAction func loginTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "completeLogin", sender: nil)
    }
    
}

