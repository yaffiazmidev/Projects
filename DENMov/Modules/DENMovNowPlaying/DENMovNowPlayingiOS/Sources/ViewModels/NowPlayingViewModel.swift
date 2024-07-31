//
//  NowPlayingViewModel.swift
//  DENMovNowPlayingiOS
//
//  Created by DENAZMI on 14/07/24.
//

import Foundation
import DENMovNowPlaying

public protocol INowPlayingViewModel {
    
}

public protocol NowPlayingViewModelDelegate: AnyObject {
    func fetch()
}

final class NowPlayingViewModel {
    
    weak var controller: NowPlayingController?
    
    private let nowPlayingLoader: NowPlayingLoader
    
    public init(nowPlayingLoader: NowPlayingLoader) {
        self.nowPlayingLoader = nowPlayingLoader
    }
}

extension NowPlayingViewModel: NowPlayingRefreshControllerDelegate {
    func didRequestLoad() {
        loadNowPlayingMovies(page: 1)
    }
}

private extension NowPlayingViewModel {
    func loadNowPlayingMovies(page: Int) {
        nowPlayingLoader.load(.init(page: page)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .failure(error):
                print(error.localizedDescription)
            case let .success(response):
                let newItems = response.items.presentedItems().map(makeCellController)
                if response.page == 1 {
                    controller?.set(newItems)
                } else {
                    controller?.append(newItems)
                }
            }
        }
    }
}

private extension NowPlayingViewModel {
    func makeCellController(for model: NowPlayingItemViewModel) -> NowPlayingCellController {
        
        let view = NowPlayingCellController(model: model)
        
//        view.didSelect = { [weak self] in
//            self?.onSelectCallback(model.id)
//        }
        
        return view
    }
}

private extension String {
    var presentedDateString: String {
        let stringToDateFormatter = DateFormatter()
        stringToDateFormatter.dateFormat = "yyyy-mm-dd"
        
        guard let date = stringToDateFormatter.date(from: self) else {
            return self
        }
        
        let dateToStringFormatter = DateFormatter()
        dateToStringFormatter.dateFormat = "yyyy"
        return dateToStringFormatter.string(from: date)
    }
}

public extension Array where Element == NowPlayingItem {
    func presentedItems() -> [NowPlayingItemViewModel] {
        return map {
            NowPlayingItemViewModel(
                id: $0.id,
                title: $0.title,
                imagePath: $0.imagePath,
                releaseDate: $0.releaseDate.presentedDateString,
                genre: "\($0.genreIds)"
            )
        }
    }
}
