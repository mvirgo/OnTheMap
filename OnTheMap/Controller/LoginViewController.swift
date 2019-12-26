//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Michael Virgo on 12/15/19.
//  Copyright © 2019 mvirgo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }

    // TODO: Update the below for proper login
    //       Current set up is just for testing flow and UI
    @IBAction func loginTapped(_ sender: Any) {
        let username = emailLabel.text ?? ""
        let password = passwordLabel.text ?? ""
        APIClient.login(username: username, password: password, completion: handleLoginResponse(success:error:))
        self.performSegue(withIdentifier: "completeLogin", sender: nil)
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            print("Success!")
        } else {
            print(error)
        }
    }
    
}

