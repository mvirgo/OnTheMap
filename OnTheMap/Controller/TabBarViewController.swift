//
//  TabBarViewController.swift
//  OnTheMap
//
//  Created by Michael Virgo on 12/16/19.
//  Copyright © 2019 mvirgo. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    // MARK: IBAction
    @IBAction func refreshTapped(_ sender: Any) {
        APIClient.getStudentLocations(completion: handleStudentData(response:error:))
        // Have to "force" refresh of table view, this will send back onto map
        //  view with table views viewWillAppear correctly refreshing it
        let x = self.viewControllers?.popLast()
        self.viewControllers?.append(x!)
        print("Refreshed!")
    }
    
    // MARK: View function
    override func viewWillAppear(_ animated: Bool) {
        // Change the back button to a LOGOUT button
        self.navigationItem.hidesBackButton = true
        let logout = UIBarButtonItem(title: "LOGOUT", style: .done, target: self, action: #selector(logoutTapped))
        self.navigationItem.leftBarButtonItem = logout
        
        // Get Student Location data to display
        APIClient.getStudentLocations(completion: handleStudentData(response:error:))
        
        super.viewWillAppear(animated)
    }
    
    // MARK: Logout button functionnality
    // Return to the login view
    @objc func logoutTapped(_ sender: Any) {
        APIClient.logout(completion: handleLogoutResponse(success:error:))
    }
    
    // MARK: Completion Handlers
    func handleStudentData(response: [StudentLocation], error: Error?) {
        if let _ = error {
            let alertVC = UIAlertController(title: "Download Failed", message: "Failed to download student information.", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.navigationController?.present(alertVC, animated: true, completion: nil)
        } else {
            LocationModel.locations = response
            // Make sure map view loads pin at start
            self.children.first?.viewWillAppear(true)
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
