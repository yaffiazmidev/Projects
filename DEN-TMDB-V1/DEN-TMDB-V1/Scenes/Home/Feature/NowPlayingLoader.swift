//
//  NowPlayingLoader.swift
//  DEN-TMDB-V1
//
//  Created by DENAZMI on 16/04/24.
//

import Foundation

protocol NowPlayingLoader {
    typealias Result = Swift.Result<NowPlayingFeed, Error>
    func execute(_ req: NowPlayingRequest, completion: @escaping (Result) -> Void)
}
