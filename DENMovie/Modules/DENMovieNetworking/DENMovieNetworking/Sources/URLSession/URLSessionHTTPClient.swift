//
//  URLSessionHTTPClient.swift
//  DENMovieNetworking
//
//  Created by DENAZMI on 20/05/24.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {
    
    public typealias Result = HTTPClient.Result
    
    private struct URLSessionTaskWrapper: HTTPClientTask {
        let wrapped: URLSessionTask
        func cancel() {
            wrapped.cancel()
        }
    }
    
    private struct UnexpectedValuesRepresentation: Error {}
    
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func request(_ request: URLRequest, completion: @escaping (Result) -> Void) -> HTTPClientTask {
        let tast = session.dataTask(with: request) { data, response, error in
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
        
        tast.resume()
        return URLSessionTaskWrapper(wrapped: tast)
    }
}
