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
        
        case locations
        case session
        case webAuth
        
        var stringValue: String {
            switch self {
            case .locations: return Endpoints.base + "/StudentLocation?limit=100"
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
    
    // Handle responses or errors for any request type
    class func handleResponseOrError<ResponseType: Decodable>(_ data: Data?, _ response: URLResponse?, _ error: Error?, _ server: String, _ completion: @escaping (ResponseType?, Error?) -> Void) {
        guard var data = data else {
            DispatchQueue.main.async {
                completion(nil, error)
            }
            return
        }
        
        let decoder = JSONDecoder()
        // Subset the response data to throw out first 5 characters if Udacity Accounts API
        if server == "udacity" {
            data = parseData(data)
        }
        
        do {
            let responseObject = try decoder.decode(ResponseType.self, from: data)
            DispatchQueue.main.async {
                completion(responseObject, nil)
            }
        } catch {
            do {
                let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
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
    
    // Send GET Requests
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            handleResponseOrError(data, response, error, "", completion)
        }
        task.resume()
    }
    
    // Send POST Requests
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            handleResponseOrError(data, response, error, "udacity", completion)
        }
        task.resume()
    }
    
    // Send DELETE Requests
    class func taskForDELETERequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            handleResponseOrError(data, response, error, "udacity", completion)
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
    
    class func logout(completion: @escaping (Bool, Error?) -> Void) {
        taskForDELETERequest(url: Endpoints.session.url, responseType: LogoutResponse.self) { response, error in
            if let _ = response {
                Auth.sessionId = ""
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func getStudentLocations(completion: @escaping (Bool, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.locations.url, responseType: Locations.self) { response, error in
            if let response = response {
                print("Successful GET.")
                completion(true, nil)
            } else {
                print("Failed GET.")
                completion(false, error)
            }
        }
    }
}
