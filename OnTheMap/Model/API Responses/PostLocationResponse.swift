//
//  PostLocationResponse.swift
//  OnTheMap
//
//  Created by Michael Virgo on 1/4/20.
//  Copyright © 2020 mvirgo. All rights reserved.
//

import Foundation

struct PostLocationResponse: Codable {
    let createdAt: String
    let objectId: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt
        case objectId
    }
}
