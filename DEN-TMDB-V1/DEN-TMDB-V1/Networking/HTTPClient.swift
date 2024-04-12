//
//  HTTPClient.swift
//  DEN-TMDB-V1
//
//  Created by DENAZMI on 13/04/24.
//

import Foundation

protocol HTTPClientTask {
    func cancel()
}

protocol HTTPClient {
    typealias Result = Swift.Result<(data: Data, response: HTTPURLResponse), Error>
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    @discardableResult
    func request(from request: URLRequest, completion: @escaping (Result) -> Void) -> HTTPClientTask
}
