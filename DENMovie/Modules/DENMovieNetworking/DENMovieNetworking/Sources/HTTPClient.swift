//
//  HTTPClient.swift
//  DENMovieNetworking
//
//  Created by DENAZMI on 20/05/24.
//

import Foundation

public protocol HTTPClientTask {
    func cancel()
}

public protocol HTTPClient {
    typealias Result = Swift.Result<(data: Data, response: HTTPURLResponse), Error>
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    @discardableResult
    func request(request: URLRequest, completion: @escaping (Result) -> Void) -> HTTPClientTask
}
