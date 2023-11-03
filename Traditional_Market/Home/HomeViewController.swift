//
//  HomeViewController.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/11/01.
//
import UIKit
import CoreLocation

class HomeViewController : BaseViewController {
    
    let conferrenceVC = ConferenceVideoController()
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource
    <ExampleCollection, ExampleModel>!
    var currentSnapshot: NSDiffableDataSourceSnapshot
    <ExampleCollection, ExampleModel>!
    static let titleElementKind = "title-element-kind"
    
    let locationManager = CLLocationManager()
    
    var authorization: CLAuthorizationStatus = .notDetermined
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navAppearance = UINavigationBarAppearance()
        navAppearance.backgroundColor = UIColor(named: "brandColor")
        self.navigationController?.navigationBar.standardAppearance = navAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navAppearance
    }
    
    override func configureView() {
        super.configureView()
        navigationItem.title = "홈"
        configureHierarchy()
        configureDataSource()
        collectionView.delegate = self
       // locationManager.delegate = self
        checkDeviceLocationAuthorization()
        
//        MarketAPIManager.shared.requstKoreaFestivalLocationBase(lati: 37.5655015943, long: 126.9787960237) { response in
//            dump(response)
//        }
        
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
            cell.configureUI(data: markets)
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
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? EventCell else { return }
        
        let popularMarketVC = PopularMarketDetailViewController()
        popularMarketVC.marketDetailInfo = item
        popularMarketVC.marketDescription = TenSelectedMarketSection(rawValue: item.marketName)
        popularMarketVC.cellDataImage = cell.eventImageView.image
        
        present(popularMarketVC, animated: true)
    }
}

extension HomeViewController {
    
    
    /// 상태가 바뀔때 마다 권한 확인
     func checkDeviceLocationAuthorization() {
        DispatchQueue.global().async {
            // 위치 서비스를 이용하고 있다면
            if CLLocationManager.locationServicesEnabled() {
                
                if #available(iOS 14.0, *) {
                    self.authorization = self.locationManager.authorizationStatus
                } else {
                    self.authorization = CLLocationManager.authorizationStatus()
                }
                
                DispatchQueue.main.async {
                    print("현재 권한 상태 - \(self.authorization)")
                    self.checkStatuesDeviceLocationAuthorization(status: self.authorization)
                }
            }
        }
    }
    
    /// 권한 설정에 따른 메서드
    /// - Parameter status: 권한 상태
    func checkStatuesDeviceLocationAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("아무것도 결정하지 않았다.")
            // p.list 알람 띄우기
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("권한 설정 거부함")
        case .denied:
            print("권한 설정 거부함")
        case .authorizedAlways:
            print("항상 권한 허용")
            locationManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            print("한번만 권한 허용")
            locationManager.startUpdatingLocation()
        case .authorized:
            print("권한 허용 됨")
            locationManager.startUpdatingLocation()
        @unknown default:
            print("어떤것이 추가 될 수 있음")
        }
    }
}
