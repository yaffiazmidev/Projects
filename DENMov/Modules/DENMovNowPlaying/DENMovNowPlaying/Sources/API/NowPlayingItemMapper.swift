//
//  NowPlayingItemMapper.swift
//  DENMovNowPlaying
//
//  Created by DENAZMI on 12/07/24.
//

import Foundation
import DENMovNetworking

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

public class NowPlayingItemMapper {
    
    private static var OK_200: Int { return 200 }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> RemoteNowPlayingFeed {
        guard response.statusCode == 200,
                let paged = try? JSONDecoder().decode(RemoteNowPlayingFeed.self, from: data)
        else {
            throw DENMovError.invalidResponse
        }
        
        return paged
    }
}
