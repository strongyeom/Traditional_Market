//
//  HomeViewController.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/11/01.
//
import UIKit

class ListViewController : BaseViewController {
    
    let conferrenceVC = ConferenceVideoController()
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource
    <ExampleCollection, ExampleModel>!
    var currentSnapshot: NSDiffableDataSourceSnapshot
    <ExampleCollection, ExampleModel>!
    static let titleElementKind = "title-element-kind"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navAppearance = UINavigationBarAppearance()
        navAppearance.backgroundColor = UIColor(named: "brandColor")
        self.navigationController?.navigationBar.standardAppearance = navAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navAppearance
    }
    
    override func configureView() {
        super.configureView()
        navigationItem.title = "리스트"
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
                                               0.425 : 0.80)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupFractionalWidth),
                                                   heightDimension: .fractionalWidth(0.4))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.interGroupSpacing = 20
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            
            let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(44))
            let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: titleSize,
                elementKind: ListViewController.titleElementKind,
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
            cell.configureUI(data: markets)
        }
        
        dataSource = UICollectionViewDiffableDataSource
        <ExampleCollection, ExampleModel>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, markets: ExampleModel) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: markets)
        }
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration
        <TitleSupplementaryView>(elementKind: ListViewController.titleElementKind) {
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

extension ListViewController : UICollectionViewDelegate {
    
   
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Cell 클릭했을때 ⭐️데이터 기반으로⭐️ 가져오기
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        guard let cell = collectionView.cellForItem(at: indexPath) as? EventCell else { return }
       
        
        let popularMarketVC = PopularMarketDetailViewController()
       
        
        if indexPath.section != 2 {
            popularMarketVC.marketDescription = TenSelectedMarketSection(rawValue: item.marketName)
        }
        popularMarketVC.sectionNumber = indexPath.section
        popularMarketVC.marketDetailInfo = item
        popularMarketVC.cellDataImage = cell.eventImageView.image
        
        let nav = UINavigationController(rootViewController: popularMarketVC)
        nav.modalPresentationStyle = .fullScreen
        
        present(nav, animated: true)
    }
}