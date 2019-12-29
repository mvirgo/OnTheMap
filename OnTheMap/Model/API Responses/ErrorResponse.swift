//
//  ErrorResponse.swift
//  OnTheMap
//
//  Created by Michael Virgo on 12/28/19.
//  Copyright © 2019 mvirgo. All rights reserved.
//

import Foundation

struct ErrorResponse: Codable {
    let status: Int
    let error: String
    
    enum CodingKeys: String, CodingKey {
        case status
        case error
    }
}

extension ErrorResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
