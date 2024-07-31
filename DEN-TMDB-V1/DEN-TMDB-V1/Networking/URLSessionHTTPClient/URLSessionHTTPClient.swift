//
//  URLSessionHTTPClient.swift
//  DEN-TMDB-V1
//
//  Created by DENAZMI on 13/04/24.
//

import Foundation

final class URLSessionHTTPClient: HTTPClient {
    
    typealias Result = HTTPClient.Result
    
    private struct URLSessionTaskWrapper: HTTPClientTask {
        let wrapped: URLSessionTask
        
        func cancel() {
            wrapped.cancel()
        }
    }
    
    private struct UnexpectedValuesRepresentation: Error {}
    
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request(from request: URLRequest, completion: @escaping (Result) -> Void) -> HTTPClientTask {
        let task = session.dataTask(with: enrich(request)) { data, response, error in
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw UnexpectedValuesRepresentation()
                }
            })
        }
        
        task.resume()
        
        return URLSessionTaskWrapper(wrapped: task)
    }
}

private extension URLSessionHTTPClient {
    func enrich(_ request: URLRequest) -> URLRequest {
        var request = request
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}

final class AuthenticatedHTTPClient: HTTPClient {
    
    typealias Result = HTTPClient.Result
    
    private struct URLSessionTaskWrapper: HTTPClientTask {
        let wrapped: URLSessionTask
        
        func cancel() {
            wrapped.cancel()
        }
    }
    
    private struct UnexpectedValuesRepresentation: Error {}
    
    private let session: URLSession
    private let config: APIConfig
    
    init(session: URLSession = .shared, config: APIConfig) {
        self.session = session
        self.config = config
    }
    
    func request(from request: URLRequest, completion: @escaping (Result) -> Void) -> HTTPClientTask {
        let task = session.dataTask(with: enrich(request, config: config)) { data, response, error in
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw UnexpectedValuesRepresentation()
                }
            })
        }
        
        task.resume()
        
        return URLSessionTaskWrapper(wrapped: task)
    }
}

private extension AuthenticatedHTTPClient {
    func enrich(_ request: URLRequest, config: APIConfig) -> URLRequest {
        guard let requestURL = request.url, var urlComponents = URLComponents(string: requestURL.absoluteString) else { return request }

        var queryItems: [URLQueryItem] = urlComponents.queryItems ?? []
        queryItems.append(.init(name: "api_key", value: config.secret))

        urlComponents.queryItems = queryItems

        guard let authenticatedRequestURL = urlComponents.url else { return request }

        var signedRequest = request
        signedRequest.url = authenticatedRequestURL
        return signedRequest
    }
}

struct APIConfig {
    let secret: String
    
    init(secret: String) {
        self.secret = secret
    }
}
