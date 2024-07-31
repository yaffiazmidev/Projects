//
//  URLSessionHTTPClient.swift
//  DENMovNetworking
//
//  Created by DENAZMI on 11/07/24.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {
    
    public typealias Result = HTTPClient.Result
    
    private struct URLSessionTaskWrapper: HTTPClientTask {
        var wrapped: URLSessionTask
        func cancel() {
            wrapped.cancel()
        }
    }
    
    private struct UnexpectedValuesRepresentation: Error {}
    
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func load(request: URLRequest, completion: @escaping (Result) -> Void) -> HTTPClientTask {
        let task = session.dataTask(with: request) { data, response, error in
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
