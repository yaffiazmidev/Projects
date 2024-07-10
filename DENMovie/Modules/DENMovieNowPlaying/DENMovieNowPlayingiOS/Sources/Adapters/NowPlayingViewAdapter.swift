//
//  NowPlayingViewAdapter.swift
//  DENMovieNowPlayingiOS
//
//  Created by DENAZMI on 25/05/24.
//

import Foundation
import DENMovieNowPlaying

final class NowPlayingViewAdapter {
    
    private weak var controller: NowPlayingController?
    
    init(controller: NowPlayingController? = nil) {
        self.controller = controller
    }
}

extension NowPlayingViewAdapter: NowPlayingView {
    func display(_ viewModel: NowPlayingViewModel) {
        
    }
}
