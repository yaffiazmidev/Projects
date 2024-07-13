//
//  NowPlayingCellController.swift
//  DENMovNowPlayingiOS
//
//  Created by DENAZMI on 12/07/24.
//

import UIKit
import DENMovNowPlaying

protocol NowPlayingCellControllerDelegate {
    func didRequestCancelLoadImage()
    func didRequestLoadImage()
}

final class NowPlayingCellController: Hashable {
    
    private let model: NowPlayingItemViewModel
//    private let delegate: NowPlayingCellControllerDelegate
    
    static func == (lhs: NowPlayingCellController, rhs: NowPlayingCellController) -> Bool {
        return lhs.model.id == rhs.model.id
    }
    
    public init(model: NowPlayingItemViewModel) {
        self.model = model
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(model.id)
    }
    
    private var cell: NowPlayingCell?
    
    func view(in collectionView: UICollectionView, forItemAt indexPath: IndexPath) -> UICollectionViewCell {
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: NowPlayingCell.id, for: indexPath) as? NowPlayingCell
        cell?.titleLabel.text = model.title
        cell?.yearLabel.text = model.releaseDate
        cell?.categoryLabel.text = model.genre
        
        return cell!
    }
}

private extension NowPlayingCellController {
    func releaseCellForReuse() {
        cell = nil
    }
}
