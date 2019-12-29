//
//  APIClient.swift
//  OnTheMap
//
//  Created by Michael Virgo on 12/26/19.
//  Copyright © 2019 mvirgo. All rights reserved.
//

import Foundation

class APIClient {
    
    struct Auth {
        static var accountKey = ""
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case session
        case webAuth
        
        var stringValue: String {
            switch self {
            case .session: return Endpoints.base + "/session"
            case .webAuth: return "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com/authenticated"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    // Udacity On the Map API needs to throw out first 5 characters
    class func parseData(_ data: Data) -> Data {
        let range = 5..<data.count
        return data.subdata(in: range)
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }

            let decoder = JSONDecoder()
            // Subset the response data to throw out first 5 characters
            let newData = parseData(data)

            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: newData)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        taskForPOSTRequest(url: Endpoints.session.url, responseType: SessionResponse.self, body: LoginRequest(udacity: Udacity(username: username, password: password))) { response, error in
            if let response = response {
                Auth.sessionId = response.session.id
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
}
