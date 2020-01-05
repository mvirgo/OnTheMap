//
//  APIClient.swift
//  OnTheMap
//
//  Created by Michael Virgo on 12/26/19.
//  Copyright © 2019 mvirgo. All rights reserved.
//

import Foundation

class APIClient {
    // MARK: Struct for authenticationn and user data
    struct Auth {
        static var accountKey = ""
        static var sessionId = ""
        static var firstName = ""
        static var lastName = ""
    }
    
    // MARK: API Endpoints
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        static let locationsBase = "/StudentLocation"
        
        case getLocations
        case postLocation
        case session
        case userData
        case webAuth
        
        var stringValue: String {
            switch self {
            case .getLocations: return Endpoints.base + Endpoints.locationsBase + "?order=-updatedAt&limit=100"
            case .postLocation: return Endpoints.base + Endpoints.locationsBase
            case .session: return Endpoints.base + "/session"
            case .userData: return Endpoints.base + "/users/\(Auth.accountKey)"
            case .webAuth: return "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com/authenticated"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    // MARK: Helper function for Udacity API
    // Udacity On the Map API needs to throw out first 5 characters
    class func parseData(_ data: Data) -> Data {
        let range = 5..<data.count
        return data.subdata(in: range)
    }
    
    // MARK: General JSON response handling
    // Handle responses or errors for any request type
    class func handleResponseOrError<ResponseType: Decodable>(_ data: Data?, _ response: URLResponse?, _ error: Error?, _ parseFront: Bool, _ completion: @escaping (ResponseType?, Error?) -> Void) {
        guard var data = data else {
            DispatchQueue.main.async {
                completion(nil, error)
            }
            return
        }
        
        let decoder = JSONDecoder()
        // Subset the response data to throw out first 5 characters if Udacity Accounts API
        if parseFront {
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
    
    // MARK: General Request Types
    // Send GET Requests
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, parseFront: Bool, completion: @escaping (ResponseType?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            handleResponseOrError(data, response, error, parseFront, completion)
        }
        task.resume()
    }
    
    // Send POST Requests
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, parseFront: Bool, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            handleResponseOrError(data, response, error, parseFront, completion)
        }
        task.resume()
    }
    
    // Send DELETE Requests
    class func taskForDELETERequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, parseFront: Bool, completion: @escaping (ResponseType?, Error?) -> Void) {
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
            handleResponseOrError(data, response, error, parseFront, completion)
        }
        task.resume()
    }
    
    // MARK: Specific API requests
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        taskForPOSTRequest(url: Endpoints.session.url, responseType: SessionResponse.self, body: LoginRequest(udacity: Udacity(username: username, password: password)), parseFront: true) { response, error in
            if let response = response {
                Auth.sessionId = response.session.id
                Auth.accountKey = response.account.key
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func logout(completion: @escaping (Bool, Error?) -> Void) {
        taskForDELETERequest(url: Endpoints.session.url, responseType: LogoutResponse.self, parseFront: true) { response, error in
            if let _ = response {
                // Clear all Auth and user data
                Auth.sessionId = ""
                Auth.accountKey = ""
                Auth.firstName = ""
                Auth.lastName = ""
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func getStudentLocations(completion: @escaping ([StudentLocation], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getLocations.url, responseType: Locations.self, parseFront: false) { response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func getUserData(completion: @escaping (Bool, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.userData.url, responseType: UserData.self, parseFront: true) { response, error in
            if let response = response {
                // Store first and last name of current user
                Auth.firstName = response.firstName
                Auth.lastName = response.lastName
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func postLocation(mapString: String, profile: String, latitude: Float, longitude: Float, completion: @escaping (Bool, Error?) -> Void) {
        let body = PostLocation(uniqueKey: Auth.accountKey, firstName: Auth.firstName, lastName: Auth.lastName, mapString: mapString, mediaURL: profile, latitude: latitude, longitude: longitude)
        taskForPOSTRequest(url: Endpoints.postLocation.url, responseType: PostLocationResponse.self, body: body, parseFront: false) { response, error in
            if let _ = response {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
}
