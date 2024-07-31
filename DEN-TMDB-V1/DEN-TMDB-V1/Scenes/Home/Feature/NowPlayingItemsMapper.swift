//
//  NowPlayingItemsMapper.swift
//  DEN-TMDB-V1
//
//  Created by DENAZMI on 16/04/24.
//

import Foundation

final class NowPlayingItemsMapper {
    
    private static var OK_200: Int { return 200 }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> RemoteNowPlayingFeed {
        guard response.statusCode == OK_200, let page = try? JSONDecoder().decode(RemoteNowPlayingFeed.self, from: data) else {
            throw RemoteNowPlayingLoader.Error.invalidResponse
        }
        
        return page
    }
}
