//
//  NowPlayingController.swift
//  DENMovNowPlayingiOS
//
//  Created by DENAZMI on 12/07/24.
//

import UIKit
import DENMovNowPlaying

public final class NowPlayingController: UICollectionViewController {
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Int, NowPlayingCellController> = {
        return .init(collectionView: collectionView) { collectionView, indexPath, controller in
            return controller.view(in: collectionView, forItemAt: indexPath)
        }
    }()
    
    var refreshController: NowPlayingRefreshController?
    
    convenience init(
        refreshController: NowPlayingRefreshController
    ) {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())
        self.refreshController = refreshController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        refreshController?.refresh()
    }
    
    func set(_ newItems: [NowPlayingCellController]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, NowPlayingCellController>()
        snapshot.appendSections([0])
        snapshot.appendItems(newItems, toSection: 0)
        dataSource.apply(snapshot)
    }
    
    func append(_ newItems: [NowPlayingCellController]) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(newItems, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

private extension NowPlayingController {
    func configureUI() {
        configureCollectionView()
    }
    
    func configureCollectionView() {
        collectionView.collectionViewLayout = createLayout()
        collectionView.dataSource = dataSource
//        collectionView.prefetchDataSource = self
        collectionView.delegate = self
        collectionView.register(NowPlayingCell.self, forCellWithReuseIdentifier: NowPlayingCell.id)
        collectionView.delegate = self
        collectionView.contentInset.top = 30
        collectionView.contentInset.bottom = 20
        collectionView.refreshControl = refreshController?.view
        collectionView.keyboardDismissMode = .onDrag
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { section, _ in
            
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(100)
                ),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 20
            section.contentInsets.leading = 16
            section.contentInsets.trailing = 16
            
            return section
        }
    }
}
