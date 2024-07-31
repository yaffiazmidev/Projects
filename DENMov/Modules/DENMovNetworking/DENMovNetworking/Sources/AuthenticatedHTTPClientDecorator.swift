//
//  AuthenticatedHTTPClientDecorator.swift
//  DENMovNetworking
//
//  Created by DENAZMI on 11/07/24.
//

import Foundation

public struct APIConfig: Decodable {
    public let secret: String
    
    public init(secret: String) {
        self.secret = secret
    }
}

public class AuthenticatedHTTPClientDecorator: HTTPClient {
    public typealias Result = HTTPClient.Result
    
    private let decoratee: HTTPClient
    private let config: APIConfig
    
    public init(decoratee: HTTPClient, config: APIConfig) {
        self.decoratee = decoratee
        self.config = config
    }
    
    public func load(request: URLRequest, completion: @escaping (Result) -> Void) -> HTTPClientTask {
        return decoratee.load(request: enrich(request)) { result in
            switch result {
            case let .failure(error): completion(.failure(error))
            case let .success(body): completion(.success(body))
            }
        }
    }
}

extension AuthenticatedHTTPClientDecorator {
    private func enrich(_ request: URLRequest) -> URLRequest {
        
        guard let requestURL = request.url, var urlComponents = URLComponents(string: requestURL.absoluteString) else {
            return request
        }
        
        var queryItems = urlComponents.queryItems ?? []
        queryItems.append(URLQueryItem(name: "api_key", value: config.secret))
        
        urlComponents.queryItems = queryItems
        
        guard let authenticatedRequestURL = urlComponents.url else { return request }
        
        var signedRequest = request
        signedRequest.url = authenticatedRequestURL
        
        return signedRequest
    }
}
