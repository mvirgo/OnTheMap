//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Michael Virgo on 12/15/19.
//  Copyright © 2019 mvirgo. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
        let logout = UIBarButtonItem(title: "LOGOUT", style: .done, target: self, action: #selector(logoutTapped))
        self.tabBarController?.navigationItem.leftBarButtonItem = logout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // TODO: Add actual logout functionality
    // Return to the login view
    @objc func logoutTapped(_ sender: Any) {
        self.navigationController!.popToRootViewController(animated: true)
    }
    
}
