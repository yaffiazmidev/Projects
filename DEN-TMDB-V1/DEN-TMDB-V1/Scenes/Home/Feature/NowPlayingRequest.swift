//
//  NowPlayingRequest.swift
//  DEN-TMDB-V1
//
//  Created by DENAZMI on 16/04/24.
//

import Foundation

struct NowPlayingRequest {
    let page: Int
    
    init(page: Int) {
        self.page = page
    }
}
