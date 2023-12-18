//
//  HomeViewController.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/11/01.
//
import UIKit

class ListViewController : BaseViewController {
    
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource
    <ExampleCollection, ExampleModel>!
    var currentSnapshot: NSDiffableDataSourceSnapshot
    <ExampleCollection, ExampleModel>!
    static let titleElementKind = "title-element-kind"
    
    lazy var collections: [ExampleCollection] = []
    let realmManager = RealmManager()
    let group = DispatchGroup()
    var thirdArray: [ExampleModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navAppearance = UINavigationBarAppearance()
        navAppearance.backgroundColor = UIColor(named: "brandColor")
        self.navigationController?.navigationBar.standardAppearance = navAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navAppearance
      
    }
    
    func bind() {
        
        let firstSection: [ExampleModel] = realmManager.firstSectionMarkets().map { ExampleModel(marketName: $0.marketName, marketType: $0.marketType, loadNameAddress: $0.loadNameAddress, address: $0.address, marketOpenCycle: $0.marketOpenCycle, publicToilet: $0.publicToilet, latitude: $0.latitude, longitude: $0.longitude, popularProducts: $0.popularProducts, phoneNumber: $0.phoneNumber)}

        let secondSection: [ExampleModel] =
        realmManager.secondSectionMarkets().map {
            ExampleModel(marketName: $0.marketName, marketType: $0.marketType, loadNameAddress: $0.loadNameAddress, address: $0.address, marketOpenCycle: $0.marketOpenCycle, publicToilet: $0.publicToilet, latitude: $0.latitude, longitude: $0.longitude, popularProducts: $0.popularProducts, phoneNumber: $0.phoneNumber)}
        
        collections = [
            ExampleCollection(title: "문체부 선정 K-관광마켓 10선", markets: firstSection),
            
            ExampleCollection(title: "요즘 뜨는 시장들", markets: secondSection)
        ]
        
        
        group.enter()
        MarketAPIManager.shared.requstKoreaFestivalLocationBase(lati: 37.566713, long: 126.978428) { response in
//            dump(response)
                
                let _ = response.map { fes in
                    self.thirdArray.append(ExampleModel(marketName: fes.title, marketType: "", loadNameAddress: fes.contenttypeid, address: fes.contentid, marketOpenCycle: "", publicToilet: "", latitude: Double(fes.mapy)!, longitude: Double(fes.mapx)!, popularProducts: "", phoneNumber: fes.tel.replacingOccurrences(of: "<br>", with: "")))
                }
                self.group.leave()
            }
            
            group.notify(queue: .main) {
                self.collections.append(ExampleCollection(title: "내 지역 문화 축제", markets: self.thirdArray))
//                print("collections2", self.collections)
                
                self.currentSnapshot = NSDiffableDataSourceSnapshot
                  <ExampleCollection, ExampleModel>()
                
                
                self.collections.forEach {
                      let collection = $0 // collections [ 0, 1 , 2]
                    self.currentSnapshot.appendSections([collection])
//                    print("---- collection.markets :\(collection.markets)")
                    self.currentSnapshot.appendItems(collection.markets)
                  }
                  
                self.dataSource.apply(self.currentSnapshot, animatingDifferences: true)
            }
        
        
        
    }
    
    
    override func configureView() {
        super.configureView()
        navigationItem.title = "리스트"
        configureHierarchy()
        configureDataSource()
        collectionView.delegate = self
        bind()
    }
    
    func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int,
                                 layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // if we have the space, adapt and go 2-up + peeking 3rd item
            let groupFractionalWidth = sectionIndex == 0 ? 0.4 : CGFloat(layoutEnvironment.container.effectiveContentSize.width > 500 ?
                                                                   0.425 : 0.80)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupFractionalWidth),
                                                   heightDimension: .fractionalWidth(0.4))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = sectionIndex == 0 ? .continuous : .groupPaging
            section.interGroupSpacing = 20
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 40, trailing: 20)
            
            let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(34))
            let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: titleSize,
                elementKind: ListViewController.titleElementKind,
                alignment: .top)
            section.boundarySupplementaryItems = [titleSupplementary]
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 0
        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider, configuration: config)
        return layout
    }
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide).inset(13)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration
        <EventCell, ExampleModel> { (cell, indexPath, markets) in
           // cell.configureUI(data: markets)
            cell.data = markets
           
        }
        
        dataSource = UICollectionViewDiffableDataSource
        <ExampleCollection, ExampleModel>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, markets: ExampleModel) -> UICollectionViewCell? in
            // Return the cell.
            print("-- indexPath : \(indexPath)")
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
