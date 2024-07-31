//
//  NowPlayingLoader.swift
//  DENMovNowPlaying
//
//  Created by DENAZMI on 12/07/24.
//

import Foundation
import DENMovNetworking

public struct PagedNowPlayingRequest {
    public let page: Int
    public let language: String
    public let query: String
    
    public init(page: Int, language: String = "ID-id", query: String = "") {
        self.page = page
        self.language = language
        self.query = query
    }
}

public protocol NowPlayingLoader {
    typealias Result = Swift.Result<NowPlayingFeed, Error>
    
    func load(_ request: PagedNowPlayingRequest, completion: @escaping (Result) ->Void)
}
