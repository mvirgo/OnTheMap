//
//  TabBarViewController.swift
//  OnTheMap
//
//  Created by Michael Virgo on 12/16/19.
//  Copyright © 2019 mvirgo. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    @IBAction func refreshTapped(_ sender: Any) {
        APIClient.getStudentLocations(completion: handleStudentData(response:error:))
        print("Refreshed!")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Change the back button to a LOGOUT button
        self.navigationItem.hidesBackButton = true
        let logout = UIBarButtonItem(title: "LOGOUT", style: .done, target: self, action: #selector(logoutTapped))
        self.navigationItem.leftBarButtonItem = logout
        
        // Get Student Location data to display
        APIClient.getStudentLocations(completion: handleStudentData(response:error:))
    }
    
    // Return to the login view
    @objc func logoutTapped(_ sender: Any) {
        APIClient.logout(completion: handleLogoutResponse(success:error:))
    }
    
    func handleStudentData(response: [StudentLocation], error: Error?) {
        if let error = error {
            print(error)
        } else {
            print("Successfully gathered student location data.")
            LocationModel.locations = response
        }
    }
    
    func handleLogoutResponse(success: Bool, error: Error?) {
        if success {
            print("Logout successful.")
        } else {
            print("Logout failed.")
        }
        self.navigationController!.popToRootViewController(animated: true)
    }
}
