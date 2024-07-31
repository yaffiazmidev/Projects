//
//  NowPlayingRefreshController.swift
//  DENMovNowPlayingiOS
//
//  Created by DENAZMI on 14/07/24.
//

import UIKit
import DENMovNowPlaying

protocol NowPlayingRefreshControllerDelegate {
    func didRequestLoad()
}

final class NowPlayingRefreshController: NSObject {
    
    private(set) lazy var view = loadView()
    
    private let delegate: NowPlayingRefreshControllerDelegate
    
    init(delegate: NowPlayingRefreshControllerDelegate) {
        self.delegate = delegate
    }
    
    @objc func refresh() {
        delegate.didRequestLoad()
    }
}

//extension NowPlayingRefreshController: NowPlayingLoadingView {
//    func display(_ viewModel: NowPlayingLoadingViewModel) {
//        viewModel.isLoading ? view.beginRefreshing() : view.endRefreshing()
//    }
//}

private extension NowPlayingRefreshController {
    func loadView() -> UIRefreshControl {
        let view = UIRefreshControl(frame: .zero)
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
