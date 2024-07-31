//
//  NowPlayingFeed.swift
//  DENMovNowPlaying
//
//  Created by DENAZMI on 12/07/24.
//

import Foundation

public struct NowPlayingFeed: Equatable {
    public let items: [NowPlayingItem]
    public let page: Int
    public let totalPages: Int
    
    public init(
        items: [NowPlayingItem],
        page: Int,
        totalPages: Int
    ) {
        self.items = items
        self.page = page
        self.totalPages = totalPages
    }
}
