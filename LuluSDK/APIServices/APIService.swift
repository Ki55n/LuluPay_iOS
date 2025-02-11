//
//  APIService.swift
//  LuluSDK
//
//  Created by boyapati kumar on 01/02/25.
//

import Foundation
import Alamofire

class APIService {
    static let shared = APIService()  // Singleton instance
    
    private init() {}  // Private initializer to enforce singleton pattern
    
//    func request(url: String,
//                 method: HTTPMethod,
//                 parameters: [String: String]? = nil,
//                 headers: [String: String]? = nil,
//                 completion: @escaping (Result<Data, Error>) -> Void) {
//        
//        guard let url = URL(string: url) else {
//            completion(.failure(APIError.invalidURL))
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = method.rawValue
//        
//        // Set headers
//        if let headers = headers {
//            for (key, value) in headers {
//                request.setValue(value, forHTTPHeaderField: key)
//            }
//        }
//        
//        // Encode parameters for x-www-form-urlencoded
//        if let parameters = parameters, method != .get {
//            let parameterArray = parameters.map { "\($0.key)=\($0.value)" }
//            let parameterString = parameterArray.joined(separator: "&")
//            request.httpBody = parameterString.data(using: .utf8)
//        }
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                DispatchQueue.main.async {
//                    completion(.failure(error))
//                }
//                return
//            }
//            
//            guard let data = data else {
//                DispatchQueue.main.async {
//                    completion(.failure(APIError.noData))
//                }
//                return
//            }
//            
//            DispatchQueue.main.async {
//                completion(.success(data))
//            }
//        }
//        
//        task.resume()
//    }
    func request(url: String,
                     method: LuHTTPMethod,
                     parameters: [String: Any]? = nil,
                     headers: [String: String]? = nil,
                     isJsonRequest: Bool = false,  // Flag to indicate if body should be JSON
                     completion: @escaping (Result<Data, Error>) -> Void) {
            
            guard let url = URL(string: url) else {
                completion(.failure(APIError.invalidURL))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            
            // Set headers
            if let headers = headers {
                for (key, value) in headers {
                    request.setValue(value, forHTTPHeaderField: key)
                }
            }
            
            // Set Content-Type to application/json if it's a JSON request
            if isJsonRequest {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                // Encode parameters as JSON
                if let parameters = parameters {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
                        request.httpBody = jsonData
                    } catch {
                        completion(.failure(APIError.decodingFailed))
                        return
                    }
                }
            } else if let parameters = parameters, method != .get {
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

                // For x-www-form-urlencoded, encode parameters as key=value
                var parameterArray = [String]()

                for (key, value) in parameters {
                    if let stringValue = value as? String {
                        let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? key
                        let encodedValue = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? stringValue
                        parameterArray.append("\(encodedKey)=\(encodedValue)")
                    } else if let intValue = value as? Int {
                        let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? key
                        let encodedValue = String(intValue).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? String(intValue)
                        parameterArray.append("\(encodedKey)=\(encodedValue)")
                    }
                    // You can handle other types (e.g., Date, Arrays) similarly if needed.
                }

                let parameterString = parameterArray.joined(separator: "&")
                request.httpBody = parameterString.data(using: .utf8)
            }
            
            // Add timeout for request if needed
//            request.timeoutInterval = 30  // 30 seconds timeout
        print("URL-",request.url)
        print("Param-",parameters)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(APIError.noData))
                    }
                    return
                }
                
                // Response validation (check if response code is 2xx)
                if let httpResponse = response as? HTTPURLResponse,
                   !(200...299).contains(httpResponse.statusCode) {
                    DispatchQueue.main.async {
                        completion(.failure(APIError.invalidResponse(statusCode: httpResponse.statusCode)))
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            }
            
            task.resume()
        }
    func requestParamasCodable(url: String,
                     method: LuHTTPMethod,
                     parameters: Any? = nil,
                     headers: [String: String]? = nil,
                     isJsonRequest: Bool = false,
                     isFormURLEncoded: Bool = false,  // Flag to indicate if body should be JSON
                 completion: @escaping (Result<Data, Error>) -> Void) {
    
        guard let url = URL(string: url) else {
            completion(.failure(APIError.invalidURL))
            return
        }
    
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
    
        // Set headers
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
    
        // If parameters are provided, encode them into JSON
        if let parameters = parameters {
            if isJsonRequest {
                // Encode as Codable (JSON)
                if let codableParameters = parameters as? Codable {
                    do {
                        let encoder = JSONEncoder()
                        encoder.keyEncodingStrategy = .convertToSnakeCase
                        let jsonData = try encoder.encode(codableParameters)
                        request.httpBody = jsonData
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    } catch {
                        completion(.failure(error))
                        return
                    }
                } else {
                    // If it's a dictionary, serialize it as JSON
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
                        request.httpBody = jsonData
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    } catch {
                        completion(.failure(error))
                        return
                    }
                }
            } else if isFormURLEncoded {
                // Encode parameters in application/x-www-form-urlencoded format
                if let dictParameters = parameters as? [String: Any] {
                    var bodyString = ""
    
                    for (key, value) in dictParameters {
                        if let value = value as? String {
                            let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? key
                            let encodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? value
                            bodyString += "\(encodedKey)=\(encodedValue)&"
                        }
                    }
    
                    if !bodyString.isEmpty {
                        // Remove the last '&' character
                        bodyString.removeLast()
                        request.httpBody = bodyString.data(using: .utf8)
                        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                    }
                }
            }
            else {
                // For non-JSON request (query parameters in URL for example)
                if let dictParameters = parameters as? [String: Any] {
                    var urlComponents = URLComponents(string: url.absoluteString)
                    var queryItems = [URLQueryItem]()
    
                    for (key, value) in dictParameters {
                        if let value = value as? String {
                            queryItems.append(URLQueryItem(name: key, value: value))
                        }
                    }
    
                    urlComponents?.queryItems = queryItems
    
                    if let finalURL = urlComponents?.url {
                        request.url = finalURL
                    } else {
                        completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
                        return
                    }
                }
            }
        }
    
    
        // Add timeout for request if needed
        //            request.timeoutInterval = 30  // 30 seconds timeout
        print("URL-",request.url)
        print("Param-",parameters)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
    
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(APIError.noData))
                }
                return
            }
    
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(APIError.invalidResponse(statusCode: -1)))
                }
                return
            }
    
            if !(200...299).contains(httpResponse.statusCode) {
                do {
                    // Parse error response body
                    let errorResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    let errorMessage = errorResponse?["message"] as? String ?? errorResponse?["error"] as? String ?? "Unknown error"
    
                    DispatchQueue.main.async {
                        completion(.failure(APIError.apiError(message: errorMessage)))
                    }
                } catch {
                    let rawResponse = String(data: data, encoding: .utf8) ?? "Unable to decode error."
                    DispatchQueue.main.async {
                        completion(.failure(APIError.apiError(message: "Parsing error. Response: \(rawResponse)")))
                    }
                }
                return
            }
    
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }
    
        task.resume()
    }
    
    func requestParamasCodable1(url: String,
                     method: LuHTTPMethod,
                     parameters: Any? = nil,
                     headers: [String: String]? = nil,
                     isJsonRequest: Bool = false,
                     isFormURLEncoded: Bool = false,  // Flag to indicate if body should be JSON
                 completion: @escaping (Result<Data, Error>) -> Void) {
    
        guard let url = URL(string: url) else {
            completion(.failure(APIError.invalidURL))
            return
        }
    
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
    
        // Set headers
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
    
        // If parameters are provided, encode them into JSON
        if let parameters = parameters {
            if isJsonRequest {
                // Encode as Codable (JSON)
                if let codableParameters = parameters as? Codable {
                    do {
                        let encoder = JSONEncoder()
                        encoder.keyEncodingStrategy = .convertToSnakeCase
                        let jsonData = try encoder.encode(codableParameters)
                        request.httpBody = jsonData
                        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
                    } catch {
                        completion(.failure(error))
                        return
                    }
                } else {
                    // If it's a dictionary, serialize it as JSON
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
                        request.httpBody = jsonData
                        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
                    } catch {
                        completion(.failure(error))
                        return
                    }
                }
            } else if isFormURLEncoded {
                // Encode parameters in application/x-www-form-urlencoded format
                if let dictParameters = parameters as? [String: Any] {
                    var bodyString = ""
    
                    for (key, value) in dictParameters {
                        if let value = value as? String {
                            let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? key
                            let encodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? value
                            bodyString += "\(encodedKey)=\(encodedValue)&"
                        }
                    }
    
                    if !bodyString.isEmpty {
                        // Remove the last '&' character
                        bodyString.removeLast()
                        request.httpBody = bodyString.data(using: .utf8)
                        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                    }
                }
            }
            else {
                // For non-JSON request (query parameters in URL for example)
                if let dictParameters = parameters as? [String: Any] {
                    var urlComponents = URLComponents(string: url.absoluteString)
                    var queryItems = [URLQueryItem]()
    
                    for (key, value) in dictParameters {
                        if let value = value as? String {
                            queryItems.append(URLQueryItem(name: key, value: value))
                        }
                    }
    
                    urlComponents?.queryItems = queryItems
    
                    if let finalURL = urlComponents?.url {
                        request.url = finalURL
                    } else {
                        completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
                        return
                    }
                }
            }
        }
    
    
        // Add timeout for request if needed
        //            request.timeoutInterval = 30  // 30 seconds timeout
        print("URL-",request.url)
        print("Param-",parameters)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
    
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(APIError.noData))
                }
                return
            }
    
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(APIError.invalidResponse(statusCode: -1)))
                }
                return
            }
    
            if !(200...299).contains(httpResponse.statusCode) {
                do {
                    // Parse error response body
                    let errorResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    let errorMessage = errorResponse?["message"] as? String ?? errorResponse?["error"] as? String ?? "Unknown error"
    
                    DispatchQueue.main.async {
                        completion(.failure(APIError.apiError(message: errorMessage)))
                    }
                } catch {
                    let rawResponse = String(data: data, encoding: .utf8) ?? "Unable to decode error."
                    DispatchQueue.main.async {
                        completion(.failure(APIError.apiError(message: "Parsing error. Response: \(rawResponse)")))
                    }
                }
                return
            }
    
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }
    
        task.resume()
    }

    //MARK: - Alamofire
    // Function to make API request using Alamofire
     func makeAlamofireRequest<T: Codable>(
        url: String,
        method: HTTPMethod = .get,
        parameters: T?,
        headers: HTTPHeaders? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        guard let parameters = parameters else {
            completion(.failure(NSError(domain: "Invalid parameters", code: 400, userInfo: nil)))
            return
        }

        // Make the request using Alamofire
        // Use JSONEncoder to convert the Codable object to a JSON dictionary
        do {
            let jsonData = try JSONEncoder().encode(parameters)
            let jsonDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            
            // Make the request using Alamofire
            AF.request(url, method: method, parameters: jsonDictionary, encoding: encoding, headers: headers)
                .validate()  // Validate the response (status code 200-299)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        completion(.success(data))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
        } catch {
            completion(.failure(error))
        }
    }

    
}




// Enum for HTTP Methods
enum LuHTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

// API Error Enum
enum APIError: Error {
    case invalidURL
    case noData
    case decodingFailed
    case invalidResponse(statusCode: Int)
    case apiError(message: String)
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL."
        case .noData: return "No data received from the server."
        case .decodingFailed: return "Failed to decode the response."
        case .invalidResponse(let statusCode): return "Invalid response. Status code: \(statusCode)"
        case .apiError(let message): return message
        }
    }
}

// API Response Wrapper
struct APIResponse<T: Decodable> {
    let data: T?
    let error: Error?
}

