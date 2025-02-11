//
//  APIService.swift
//  LuluSDK
//
//  Created by boyapati kumar on 01/02/25.
//

import Foundation

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
                     method: HTTPMethod,
                     parameters: [String: String]? = nil,
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
                // For x-www-form-urlencoded, encode parameters as key=value
                let parameterArray = parameters.map { "\($0.key)=\($0.value)" }
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
}

// Enum for HTTP Methods
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

// API Error Enum
enum APIError: Error {
    case invalidURL
    case invalidParameters
    case noData
    case decodingFailed
    case invalidResponse(statusCode: Int)  // For invalid HTTP responses

}

// API Response Wrapper
struct APIResponse<T: Decodable> {
    let data: T?
    let error: Error?
}

