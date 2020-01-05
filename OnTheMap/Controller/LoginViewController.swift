//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Michael Virgo on 12/15/19.
//  Copyright © 2019 mvirgo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    // MARK: View functions
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.setNavigationBarHidden(true, animated: animated)
        passwordLabel.text = "" // Make sure password removed each time
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }

    // MARK: IBActions
    
    // Login using the input username and password
    @IBAction func loginTapped(_ sender: Any) {
        let username = emailLabel.text ?? ""
        let password = passwordLabel.text ?? ""
        APIClient.login(username: username, password: password, completion: handleLoginResponse(success:error:))
    }
    @IBAction func loginViaWebsiteTapped(_ sender: Any) {
        UIApplication.shared.open(APIClient.Endpoints.webAuth.url, options: [:], completionHandler: nil)
    }
    
    // MARK: Completion handler for login
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            print(APIClient.Auth.sessionId)
            self.performSegue(withIdentifier: "completeLogin", sender: nil)
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    // MARK: Alert View
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.navigationController?.present(alertVC, animated: true, completion: nil)
    }
    
}

