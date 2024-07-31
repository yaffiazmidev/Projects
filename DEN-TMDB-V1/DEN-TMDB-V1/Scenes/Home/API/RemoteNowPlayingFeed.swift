//
//  RemoteNowPlayingFeed.swift
//  DEN-TMDB-V1
//
//  Created by DENAZMI on 16/04/24.
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
