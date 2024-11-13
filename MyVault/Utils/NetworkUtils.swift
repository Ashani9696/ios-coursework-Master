//
//  NetworkUtils.swift
//  MyVault
//
//  Created by Mudara on 2023-09-25.
//

import Foundation
import Combine

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
}

class NetworkManager {
    static let shared = NetworkManager()
    
    //private let baseURL = "https://ios-backend-5zdx.onrender.com/"
      private let baseURL = "http://127.0.0.1:8888/"
    
    private init() {}
    
    func request<T: Decodable>(_ path: String, method: HTTPMethod, query: [String: Any]? = nil, body: [String: Any]? = nil, headers: [String: Any]? = nil, response: T.Type) -> AnyPublisher<T, Error> {
            var urlString = "\(baseURL)\(path)"
            
            if let queryParameters = query {
                var queryItems: [URLQueryItem] = []
                for (key, value) in queryParameters {
                    let queryItem = URLQueryItem(name: key, value: "\(value)")
                    queryItems.append(queryItem)
                }
                
                var components = URLComponents(string: urlString)!
                components.queryItems = queryItems
                urlString = components.url!.absoluteString
            }
            
            var urlRequest = URLRequest(url: URL(string: urlString)!)
            urlRequest.httpMethod = method.rawValue
            
            if let body = body {
                urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
            }
            
            if let headers = headers {
                for (key, value) in headers {
                    urlRequest.setValue(value as! String, forHTTPHeaderField: key)
                }
            }
        
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let session = URLSession.shared
            
            return session.dataTaskPublisher(for: urlRequest)
                .map(\.data)
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
}
