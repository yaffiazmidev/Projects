//
//  NowPlayingViewModel.swift
//  DENMovieNowPlaying
//
//  Created by DENAZMI on 25/05/24.
//

import Foundation

public struct NowPlayingViewModel: Equatable {
    public let pageNumber: Int
    public let items: [NowPlayingItemViewModel]
}
