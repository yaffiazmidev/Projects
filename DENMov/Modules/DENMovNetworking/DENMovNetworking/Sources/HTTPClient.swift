//
//  HTTPClient.swift
//  DENMovNetworking
//
//  Created by DENAZMI on 11/07/24.
//

import Foundation

public protocol HTTPClientTask {
    func cancel()
}

public protocol HTTPClient {
    typealias Result = Swift.Result<(data: Data, response: HTTPURLResponse), Error>
    
    @discardableResult
    func load(request: URLRequest, completion: @escaping (Result) -> Void) -> HTTPClientTask
}
