//
//  HomeInteractor.swift
//  DEN-TMDB-V1
//
//  Created by DENAZMI on 16/04/24.
//

import Foundation

protocol IHomeInteractor {
    var nowPlayingPage: Int { get set }
    
    func fetchNowPlaying()
}

class HomeInteractor: IHomeInteractor {
    
    private let presenter: IHomePresenter
    private let nowPlayingLoader: NowPlayingLoader
    
    var nowPlayingPage: Int = 1
    
    init(presenter: IHomePresenter, nowPlayingLoader: NowPlayingLoader) {
        self.presenter = presenter
        self.nowPlayingLoader = nowPlayingLoader
    }
    
    func fetchNowPlaying() {
        let request = NowPlayingRequest(page: nowPlayingPage)
        nowPlayingLoader.execute(request) { [weak self] result in
            guard let self = self else { return }
            self.presenter.presentNowPlaying(with: result)
        }
    }
}
