//
//  NowPlayingLoader.swift
//  DENMovieNowPlaying
//
//  Created by DENAZMI on 20/05/24.
//

import Foundation
import DENMovieNetworking

public struct PagedNowPlayingRequest: Equatable {
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
    
    func execute(_ request: PagedNowPlayingRequest, completion: @escaping (Result) -> Void)
}
