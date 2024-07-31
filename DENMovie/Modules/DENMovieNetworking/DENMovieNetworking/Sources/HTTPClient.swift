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
    
    @discardableResult
    func request(_ request: URLRequest, completion: @escaping (Result) -> Void) -> HTTPClientTask
}
