//
//  NowPlayingLoader.swift
//  DENMovieNowPlaying
//
//  Created by DENAZMI on 20/05/24.
//

import Foundation
import DENMovieNetworking

public protocol NowPlayingLoader {
    typealias Result = Swift.Result<NowPlayingFeed, Error>
    
    func execute(_ request: URLRequest, completion: @escaping (Result) -> Void)
}
