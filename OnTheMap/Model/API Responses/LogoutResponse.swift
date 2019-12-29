//
//  LogoutResponse.swift
//  OnTheMap
//
//  Created by Michael Virgo on 12/28/19.
//  Copyright © 2019 mvirgo. All rights reserved.
//

import Foundation

struct LogoutResponse: Codable {
    let session: SessionOut
}

struct SessionOut: Codable {
    let id: String
    let expiration: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case expiration
    }
}
