//
//  HomePresenter.swift
//  DEN-TMDB-V1
//
//  Created by DENAZMI on 16/04/24.
//

import Foundation

protocol IHomePresenter {
    func presentNowPlaying(with result: NowPlayingLoader.Result)
}

class HomePresenter: IHomePresenter {
    
    weak var controller: IHomeController?
    
    init() {}
    
    func presentNowPlaying(with result: NowPlayingLoader.Result) {
        switch result {
        case .success(let response):
            controller?.displayNowPlayingMovies(with: response.items)
        case .failure(let error):
            controller?.displayError(with: error.localizedDescription)
        }
    }
}
