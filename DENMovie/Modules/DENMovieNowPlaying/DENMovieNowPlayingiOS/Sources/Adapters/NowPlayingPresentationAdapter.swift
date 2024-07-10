//
//  NowPlayingPresentationAdapter.swift
//  DENMovieNowPlayingiOS
//
//  Created by DENAZMI on 25/05/24.
//

import Foundation
import DENMovieNowPlaying

final class NowPlayingPresentationAdapter {
    
    var presenter: NowPlayingPresenter?
    
    private let nowPlayingLoader: NowPlayingLoader
    
    init(nowPlayingLoader: NowPlayingLoader) {
        self.nowPlayingLoader = nowPlayingLoader
    }
}

extension NowPlayingPresentationAdapter: NowPlayingRefreshControllerDelegate {
    func didRequestLoad() {
        presenter?.didStartLoading()
        loadNowPlayingMovies(page: 0)
    }
}

private extension NowPlayingPresentationAdapter {
    func loadNowPlayingMovies(page: Int) {
        nowPlayingLoader.execute(.init(page: 1)) { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure:
                self.presenter?.didFinishLoadingWithError()
            case let .success(feed):
                self.presenter?.didFinishLoading(with: feed)
            }
        }
    }
}

