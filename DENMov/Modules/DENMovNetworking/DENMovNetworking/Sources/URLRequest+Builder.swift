//
//  URLRequest+Builder.swift
//  DENMovNetworking
//
//  Created by DENAZMI on 11/07/24.
//

import Foundation

public extension URLRequest {
    
    struct Builder {
        
        public enum HTTPMethod: String {
            case GET
            case POST
            case PUT
            case PATCH
            case DELETE
            case UPDATE
        }
        
        private var components = URLComponents()
        private var method: HTTPMethod = .GET
        private var headers: [String: String] = [:]
        private var body: Data?
        
        private init() {}
        
        static func url(_ url: URL) -> Builder {
            var builder = Builder()
            builder.components.scheme = url.scheme
            builder.components.host = url.host
            builder.components.path = url.path
            return builder
        }
        
        public func method(_ method: HTTPMethod) -> Builder {
            var builder = self
            builder.method = method
            return builder
        }
        
        public func path(_ path: String) -> Builder {
            var builder = self
            builder.components.path += path
            return builder
        }
        
        public func headers(key: String, value: String) -> Builder {
            var builder = self
            builder.headers[key] = value
            return builder
        }
        
        public func body(data: Encodable) -> Builder {
            var builder = self
            builder.body = try? JSONEncoder().encode(data)
            return builder
        }
        
        public func queries(_ queries: [URLQueryItem]) -> Builder {
            var builder = self
            builder.components.queryItems = queries.compactMap { $0 }
            return builder
        }
        
        public func build() -> URLRequest {
            guard let url = components.url else {
                fatalError("URL is not set")
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request.allHTTPHeaderFields = headers
            request.httpBody = body
            
            return request
        }
    }
    
    static func url(_ url: URL) -> Builder {
        return Builder.url(url)
    }
}
