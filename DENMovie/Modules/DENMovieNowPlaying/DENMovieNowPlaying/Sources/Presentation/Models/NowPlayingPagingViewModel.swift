//
//  NowPlayingPagingViewModel.swift
//  DENMovieNowPlaying
//
//  Created by DENAZMI on 25/05/24.
//

import Foundation

public struct NowPlayingPagingViewModel {
    public let isLoading: Bool
    public let isLast: Bool
    public let pageNumber: Int
    
    public var nextPage: Int? {
        return isLast ? nil : pageNumber + 1
    }
    
    public init(isLoading: Bool, isLast: Bool, pageNumber: Int) {
        self.isLoading = isLoading
        self.isLast = isLast
        self.pageNumber = pageNumber
    }
}
