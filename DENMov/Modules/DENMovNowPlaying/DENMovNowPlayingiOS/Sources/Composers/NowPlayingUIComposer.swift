//
//  NowPlayingUIComposer.swift
//  DENMovNowPlayingiOS
//
//  Created by DENAZMI on 14/07/24.
//

import Foundation
import DENMovNowPlaying

public enum NowPlayingUIComposer {
    
    public static func compose(
        loader: NowPlayingLoader
    ) -> NowPlayingController {
        
        let viewModel = NowPlayingViewModel(nowPlayingLoader: MainQueueDispatchDecorator(loader))
        let refreshController = NowPlayingRefreshController(delegate: viewModel)
        let controller = NowPlayingController(refreshController: refreshController)
        
        viewModel.controller = controller
        
        return controller
    }
}

extension MainQueueDispatchDecorator: NowPlayingLoader where T == NowPlayingLoader {
    typealias Result = NowPlayingLoader.Result
    public func load(_ request: PagedNowPlayingRequest, completion: @escaping (NowPlayingLoader.Result) -> Void) {
        decoratee.load(request) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

public final class MainQueueDispatchDecorator<T> {
    private(set) public var decoratee: T
    
    public init(_ decoratee: T) {
        self.decoratee = decoratee
    }
    
    public func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }
        
        completion()
    }
}
