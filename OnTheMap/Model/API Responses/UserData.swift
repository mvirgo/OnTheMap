//
//  UserData.swift
//  OnTheMap
//
//  Created by Michael Virgo on 1/4/20.
//  Copyright © 2020 mvirgo. All rights reserved.
//

import Foundation

struct UserData: Codable {
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
