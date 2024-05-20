//
//  HttpClient.swift
//  DENMovieNetworking
//
//  Created by DENAZMI on 20/05/24.
//

import Foundation

public protocol HttpClientTask {
    func cancel()
}

public protocol HttpClient {
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    @discardableResult
    func request(request: URLRequest) async throws -> (Data, HTTPURLResponse)
}
