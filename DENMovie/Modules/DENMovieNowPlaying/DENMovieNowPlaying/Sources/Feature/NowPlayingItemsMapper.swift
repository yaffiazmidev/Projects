//
//  NowPlayingItemsMapper.swift
//  DENMovieNowPlaying
//
//  Created by DENAZMI on 20/05/24.
//

import Foundation

struct RemoteNowPlayingFeed: Decodable {

  struct RemoteNowPlayingItem: Decodable {
    let id: Int
    let original_title: String
    var poster_path: String?
    let genre_ids: [Int]?
    let release_date: String?
  }

  let results: [RemoteNowPlayingItem]
  let page: Int
  let total_pages: Int
}

final class NowPlayingItemsMapper {
    
    private static var OK_200: Int { return 200 }
    
    static func map(data: Data, from response: HTTPURLResponse) throws -> RemoteNowPlayingFeed {
        
        guard response.statusCode == OK_200, let page = try? JSONDecoder().decode(RemoteNowPlayingFeed.self, from: data) else {
            throw RemoteNowPlayingLoader.Error.invalidResponse
        }
        
        return page
    }
}
