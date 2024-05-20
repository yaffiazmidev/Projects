//
//  HomeController.swift
//  DEN-TMDB-V1
//
//  Created by DENAZMI on 13/04/24.
//

import UIKit

protocol IHomeController: AnyObject {
    func displayNowPlayingMovies(with items: [NowPlayingItem])
    func displayError(with message: String)
}

class HomeController: UICollectionViewController {
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Int, NowPlayingCellController> = {
        return .init(collectionView: collectionView) { collectionView, indexPath, controller in
            return controller.view(in: collectionView, forItemAt: indexPath)
        }
    }()
    
    var interactor: IHomeInteractor?
    private let nowPlayingMovies: [NowPlayingItem] = []
    
    convenience init() {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        defaultRequest()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.collectionViewLayout = createLayout()
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        collectionView.register(NowPlayingCell.self, forCellWithReuseIdentifier: NowPlayingCell.id)
    }
    
    private func defaultRequest() {
        interactor?.fetchNowPlaying()
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
    
    public override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isDragging else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if (offsetY > contentHeight - scrollView.frame.height) {
            interactor?.nowPlayingPage += 1
            interactor?.fetchNowPlaying()
        }
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

extension HomeController: IHomeController {
    func displayNowPlayingMovies(with items: [NowPlayingItem]) {
        print(items.compactMap({ $0.title }))
    }
    
    func displayError(with message: String) {
        print(message)
    }
}



protocol NowPlayingCellControllerDelegate {
    func didRequestCancelLoadImage()
    func didRequestLoadImage()
}

final class NowPlayingCellController: Hashable {
    
    private let model: NowPlayingItemViewModel
    private let delegate: NowPlayingCellControllerDelegate
    
    var didSelect: (() -> Void)?
    
    init(model: NowPlayingItemViewModel, delegate: NowPlayingCellControllerDelegate) {
        self.model = model
        self.delegate = delegate
    }
    
    static func == (lhs: NowPlayingCellController, rhs: NowPlayingCellController) -> Bool {
        return lhs.model.id == rhs.model.id
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
    
    func cancelLoad() {
        delegate.didRequestCancelLoadImage()
        releaseCellForReuse()
    }
    
    func prefetch() {
        delegate.didRequestLoadImage()
    }
    
    func select() {
        didSelect?()
    }
}

private extension NowPlayingCellController {
    func releaseCellForReuse() {
        cell = nil
    }
}

extension NowPlayingCellController: NowPlayingImageView {
    func display(_ model: NowPlayingImageViewModel<UIImage>) {
        cell?.contentView.isShimmering = model.isLoading
        cell?.thumbnailImageView.image = model.image
    }
}

public struct NowPlayingImageViewModel<Image> {

  public let image: Image?
  public let isLoading: Bool

  public init(image: Image?, isLoading: Bool) {
    self.image = image
    self.isLoading = isLoading
  }
}

public final class NowPlayingCell: UICollectionViewCell {
    
    static var id: String {
        return String(describing: NowPlayingCell.self)
    }
    
    private(set) public var thumbnailImageView = UIImageView()
    private let rightContentStackView = UIStackView()
    private(set) public var titleLabel = UILabel()
    private(set) public var yearLabel = UILabel()
    private(set) public var categoryLabel = UILabel()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Unimplemented")
    }
}

private extension NowPlayingCell {
    func configureUI() {
        configureThumbnailImageView()
        configureRightContentStackView()
        configureCategoryLabel()
    }
    
    func configureThumbnailImageView() {
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.backgroundColor = .lightGray
        thumbnailImageView.layer.cornerRadius = 4
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.contentMode = .scaleToFill
        
        contentView.addSubview(thumbnailImageView)
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnailImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            thumbnailImageView.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor)
        ])
    }

    func configureRightContentStackView() {
        rightContentStackView.translatesAutoresizingMaskIntoConstraints = false
        rightContentStackView.axis = .vertical
        rightContentStackView.alignment = .top
        rightContentStackView.spacing = 4
        
        contentView.addSubview(rightContentStackView)
    
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: rightContentStackView,
                attribute: .leading,
                relatedBy: .equal,
                toItem: thumbnailImageView,
                attribute: .trailing,
                multiplier: 1,
                constant: 16
            ),
            rightContentStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            rightContentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        configureTitleLabel()
        configureYearLabel()
    }
    
    func configureTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 2
        
        rightContentStackView.addArrangedSubview(titleLabel)
    }
    
    func configureYearLabel() {
        yearLabel.font = .systemFont(ofSize: 16, weight: .regular)
        yearLabel.textColor = .black
        
        rightContentStackView.addArrangedSubview(yearLabel)
    }
    
    func configureCategoryLabel() {
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.font = .systemFont(ofSize: 12, weight: .regular)
        categoryLabel.textColor = .gray
        categoryLabel.text = "LOREM, IPSUM, DOLOR"
        
        contentView.addSubview(categoryLabel)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: categoryLabel,
                attribute: .leading,
                relatedBy: .equal,
                toItem: thumbnailImageView,
                attribute: .trailing,
                multiplier: 1,
                constant: 16
            ),
            categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}


public protocol NowPlayingImageView {
  associatedtype Image
  func display(_ model: NowPlayingImageViewModel<Image>)
}

public final class NowPlayingImagePresenter<View: NowPlayingImageView, Image> where View.Image == Image {

  private let view: View
  private let imageTransformer: (Data) -> Image?

  public init(view: View, imageTransformer: @escaping (Data) -> Image?) {
    self.view = view
    self.imageTransformer = imageTransformer
  }

  public func didStartLoadingImageData() {
    view.display(NowPlayingImageViewModel<Image>(image: nil, isLoading: true))
  }

  public func didFinishLoadingImageData(with data: Data) {
    let image = imageTransformer(data)
    view.display(NowPlayingImageViewModel<Image>(image: image, isLoading: false))
  }
}


public extension UIView {
  var isShimmering: Bool {
    set {
      if newValue {
        startShimmering()
      } else {
        stopShimmering()
      }
    }
    
    get { layer.mask?.animation(forKey: shimmerAnimationKey) != nil }
  }
}

private extension UIView {
  var shimmerAnimationKey: String {
      "SHIMMER_ANIMATION_KEY"
  }
  
  func startShimmering() {
    let white = UIColor.white.cgColor
    let alpha = UIColor.white.withAlphaComponent(0.75).cgColor
    let width = bounds.width
    let height = bounds.height
    
    let gradient = CAGradientLayer()
    gradient.colors = [alpha, white, alpha]
    gradient.startPoint = CGPoint(x: 0.0, y: 0.4)
    gradient.endPoint = CGPoint(x: 1.0, y: 0.6)
    gradient.locations = [0.4, 0.5, 0.6]
    gradient.frame = CGRect(x: -width, y: 0, width: width*3, height: height)
    
    let animation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.locations))
    animation.fromValue = [0.0, 0.1, 0.2]
    animation.toValue = [0.8, 0.9, 1.0]
    animation.duration = 1.25
    animation.repeatCount = .infinity
    gradient.add(animation, forKey: shimmerAnimationKey)
      
    layer.mask = gradient
  }
  
  func stopShimmering() {
    layer.mask = nil
  }
}

public struct NowPlayingItemViewModel: Equatable {
    public let id: Int
    public let title: String
    public let imagePath: String
    public let releaseDate: String
    public let genre: String
    
    public init(
        id: Int,
        title: String,
        imagePath: String,
        releaseDate: String,
        genre: String
    ) {
        self.id = id
        self.title = title
        self.imagePath = imagePath
        self.releaseDate = releaseDate
        self.genre = genre
    }
}
