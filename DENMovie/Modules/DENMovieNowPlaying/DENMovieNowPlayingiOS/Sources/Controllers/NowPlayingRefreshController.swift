//
//  NowPlayingRefreshController.swift
//  DENMovieNowPlayingiOS
//
//  Created by DENAZMI on 25/05/24.
//

import UIKit

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

private extension NowPlayingRefreshController {
    func loadView() -> UIRefreshControl {
        let view = UIRefreshControl(frame: .zero)
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
