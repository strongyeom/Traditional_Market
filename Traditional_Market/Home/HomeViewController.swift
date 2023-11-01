//
//  HomeViewController.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/11/01.
//
import UIKit

class HomeViewController : BaseViewController {
    
    let conferrenceVC = ConferenceVideoController()
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource
    <ExampleCollection, ExampleModel>!
    var currentSnapshot: NSDiffableDataSourceSnapshot
    <ExampleCollection, ExampleModel>!
    static let titleElementKind = "title-element-kind"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureView() {
        super.configureView()
        navigationItem.title = "홈"
        configureHierarchy()
        configureDataSource()
        collectionView.delegate = self
    }
    
    
    func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                 heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            // if we have the space, adapt and go 2-up + peeking 3rd item
            let groupFractionalWidth = CGFloat(layoutEnvironment.container.effectiveContentSize.width > 500 ?
                0.425 : 0.85)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupFractionalWidth),
                                                  heightDimension: .absolute(250))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.interGroupSpacing = 20
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

            let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .estimated(44))
            let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: titleSize,
                elementKind: HomeViewController.titleElementKind,
                alignment: .top)
            section.boundarySupplementaryItems = [titleSupplementary]
            return section
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20

        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider, configuration: config)
        return layout
    }
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration
        <EventCell, ExampleModel> { (cell, indexPath, markets) in
            // Populate the cell with our item description.
            cell.exampleText.text = markets.marketName

        }
        
        dataSource = UICollectionViewDiffableDataSource
        <ExampleCollection, ExampleModel>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, markets: ExampleModel) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: markets)
        }
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration
        <TitleSupplementaryView>(elementKind: HomeViewController.titleElementKind) {
            (supplementaryView, string, indexPath) in
            if let snapshot = self.currentSnapshot {
                // Populate the view with our section's description.
                let videoCategory = snapshot.sectionIdentifiers[indexPath.section]
                supplementaryView.label.text = videoCategory.title
            }
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: supplementaryRegistration, for: index)
        }
        
        currentSnapshot = NSDiffableDataSourceSnapshot
            <ExampleCollection, ExampleModel>()
        conferrenceVC.collections.forEach {
            let collection = $0
            currentSnapshot.appendSections([collection])
            currentSnapshot.appendItems(collection.markets)
        }
        
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
    
}

extension HomeViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Cell 클릭했을때 ⭐️데이터 기반으로⭐️ 가져오기
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        dump(item)
    }
}
