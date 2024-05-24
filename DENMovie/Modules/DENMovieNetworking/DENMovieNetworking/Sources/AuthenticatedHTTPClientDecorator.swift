//
//  AuthenticatedHTTPClientDecorator.swift
//  DENMovieNetworking
//
//  Created by DENAZMI on 24/05/24.
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
    
    public func request(_ request: URLRequest, completion: @escaping (Result) -> Void) -> HTTPClientTask {
        return decoratee.request(enrich(request, with: config)) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .failure(error): completion(.failure(error))
            case let .success(body): completion(.success(body))
            }
        }
    }
}

extension AuthenticatedHTTPClientDecorator {
    
    private func enrich(_ request: URLRequest, with config: APIConfig) -> URLRequest {
        
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
