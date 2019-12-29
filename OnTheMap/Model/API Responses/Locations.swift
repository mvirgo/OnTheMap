//
//  Locations.swift
//  OnTheMap
//
//  Created by Michael Virgo on 12/29/19.
//  Copyright © 2019 mvirgo. All rights reserved.
//

import Foundation

struct Locations: Codable {
    let results: [StudentLocation]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}
