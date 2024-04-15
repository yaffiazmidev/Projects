//
//  HomeInteractor.swift
//  DEN-TMDB-V1
//
//  Created by DENAZMI on 16/04/24.
//

import Foundation

protocol IHomeInteractor {
    func fetchNowPlaying()
}

class HomeInteractor: IHomeInteractor {
    
    private let presenter: IHomePresenter
    private let nowPlayingLoader: NowPlayingLoader
    
    init(presenter: IHomePresenter, nowPlayingLoader: NowPlayingLoader) {
        self.presenter = presenter
        self.nowPlayingLoader = nowPlayingLoader
    }
    
    func fetchNowPlaying() {
        let request = NowPlayingRequest(page: 1)
        nowPlayingLoader.execute(request) { [weak self] result in
            guard let self = self else { return }
            self.presenter.presentNowPlaying(with: result)
        }
    }
}
