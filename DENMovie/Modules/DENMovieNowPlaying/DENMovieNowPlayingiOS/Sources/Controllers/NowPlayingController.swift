//
//  NowPlayingController.swift
//  DENMovieNowPlayingiOS
//
//  Created by DENAZMI on 22/05/24.
//

import UIKit
import DENMovieNowPlaying

public final class NowPlayingController: UICollectionViewController {
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Int, NowPlayingCellController> = {
        return .init(collectionView: collectionView) { collectionView, indexPath, controller in
            return controller.view(in: collectionView, forItemAt: indexPath)
        }
    }()
    
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    var refreshController: NowPlayingRefreshController?
    
    convenience init(
        refreshController: NowPlayingRefreshController
    ) {
        self.refreshController = refreshController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        refreshController?.refresh()
    }
}
