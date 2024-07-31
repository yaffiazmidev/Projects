//
//  RemoteNowPlayingFeedMapper.swift
//  DEN-TMDB-V1
//
//  Created by DENAZMI on 16/04/24.
//

import Foundation

final class RemoteNowPlayingFeedMapper {
    static func map(_ data: Data, from response: HTTPURLResponse) -> NowPlayingLoader.Result {
        do {
            let items = try NowPlayingItemsMapper.map(data, from: response)
            return .success(items.asPageDTO)
        } catch {
            return .failure(error)
        }
    }
}

private extension RemoteNowPlayingFeed {
    var asPageDTO: NowPlayingFeed {
        return NowPlayingFeed(
            items: results.asCardDTO,
            page: page,
            totalPages: total_pages
        )
    }
}

private extension Array where Element == RemoteNowPlayingFeed.RemoteNowPlayingItem {
    var asCardDTO: [NowPlayingItem] {
        return map { item in
            NowPlayingItem(
                id: item.id,
                title: item.original_title,
                imagePath: item.poster_path ?? "",
                releaseDate: item.release_date ?? "",
                genreIds: item.genre_ids ?? []
            )
        }
    }
}
