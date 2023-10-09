//
//  DetailViewController.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/29.
//

import UIKit

final class DetailViewController: BaseViewController {
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    var selectedMarket: TraditionalMarketRealm?
    
    let viewModel = TraditionalMarketViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    // 저장을 눌렀을때 즐겨찾기 버튼 활성화 됌 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.favoriteMarket.bind { _ in
            self.collectionView.reloadData()
        }
    }
    
    override func configureView() {
        view.backgroundColor = .lightGray
        view.addSubview(collectionView)
        
        guard let selectedMarket else { return }
        sheetPresent()
        setCollectionView()
        
        viewModel.requestImage(search: selectedMarket)
        viewModel.naverImageList.bind { _ in
            self.collectionView.reloadData()
        }
        
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

extension DetailViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.naverImageList.value.items.count
    }
    
    // 해당 시장 이미지
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DetailMarketInfoCell.self), for: indexPath) as? DetailMarketInfoCell else { return UICollectionViewCell()}
        
        let data = viewModel.naverImageList.value.items[indexPath.item]
       // cell.configureCell(market: data)
        cell.ImageUrl = data.link
        return cell
    }
   
    // 시장 정보 칸
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let selectedMarket else { return UICollectionReusableView() }
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: DetailHeaderCell.self), for: indexPath) as? DetailHeaderCell else { return UICollectionReusableView() }
            header.configureCell(market: selectedMarket)
            header.delegate = self
            return header
        } else {
            return UICollectionReusableView()
        }
    }
}

extension DetailViewController {
    
    fileprivate func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DetailMarketInfoCell.self, forCellWithReuseIdentifier: String(describing: DetailMarketInfoCell.self))
        collectionView.register(DetailHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: DetailHeaderCell.self))
    }
    

    
    fileprivate func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let spacing: CGFloat = 8
        let width = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: (width - (spacing * 4)) / 3 , height: (width - (spacing * 4)) / 3)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.headerReferenceSize = CGSize(width: width, height: width * 0.45)
        return layout
    }
    
    
    fileprivate func sheetPresent() {
        if let sheetPresentationController {
          
            // detent의 식별자, 식별자를 지정하지 않으면 시스템에서 랜덤한 식별자가 생성
            let detentIdentifier = UISheetPresentationController.Detent.Identifier("customDetent")
            
            let minCustomDetent = UISheetPresentationController.Detent.custom(identifier: detentIdentifier) { _ in
                return 200
            }
            sheetPresentationController.detents = [minCustomDetent, .large()]

            // grabber 설정
            sheetPresentationController.prefersGrabberVisible = true
            // present시 백그라운드 dim 처리 유무 ( 어떤 상태일때 회색으로 만들것이냐 ) - dim 처리를 하지 않기 때문에 유저 인터렉션에 반응할 수 있음
            sheetPresentationController.largestUndimmedDetentIdentifier = minCustomDetent.identifier
            // 코너 주기
            sheetPresentationController.preferredCornerRadius = 30
        }
    }
}

extension DetailViewController: IsLikeDelegate {
    func isLikeClickedEvent() {
        print("델리겟 DetailViewController에서 탐")
       let stampVC = StampViewController()
        stampVC.selectedMarket = selectedMarket
        let nav = UINavigationController(rootViewController: stampVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
        // 1. DetailVC를 내리고 StampVC를 올리는것이 나을까?
        // 2. DetailVC 위로 StampVC를 덮어씌우는것이 좋을까?
    }
}
