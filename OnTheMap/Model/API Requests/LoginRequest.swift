//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Michael Virgo on 12/26/19.
//  Copyright © 2019 mvirgo. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    let udacity: Udacity
}

struct Udacity: Codable {
    let username: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case username
        case password
    }
}
