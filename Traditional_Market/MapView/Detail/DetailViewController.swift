//
//  DetailViewController.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/29.
//

import UIKit
import RealmSwift
import Kingfisher

class DetailViewController: BaseViewController {
    
    let label = UILabel()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    var selectedMarket: TraditionalMarketRealm?
    
    var naverImageList: NaverMarketImage = NaverMarketImage(lastBuildDate: "", total: 0, start: 0, display: 0, items: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureView() {
        super.configureView()
        sheetPresent()
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
       
        requestImage(search: selectedMarket!.marketName)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DetailMarketInfoCell.self, forCellWithReuseIdentifier: String(describing: DetailMarketInfoCell.self))
        collectionView.register(DetailHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: DetailHeaderCell.self))
        
    }
    
    func requestImage(search: String) {
        MarketAPIManager.shared.requestNaverImage(search: selectedMarket!.marketName) { response in
            dump("DetailViewController - \(response)")
            DispatchQueue.main.async {
                self.naverImageList.items.append(contentsOf: response.items)
                self.collectionView.reloadData()
            }
        }
    }
    
    func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let spacing: CGFloat = 10
        let width = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: (width - (spacing * 4)) / 3 , height: (width - (spacing * 4)) / 3)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.headerReferenceSize = CGSize(width: width, height: width * 0.4)
        return layout
    }
    
    
}

extension DetailViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return naverImageList.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // guard let selectedMarket else { return UICollectionViewCell() }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DetailMarketInfoCell.self), for: indexPath) as? DetailMarketInfoCell else { return UICollectionViewCell()}
        
        let data = naverImageList.items[indexPath.item]
        let url = URL(string: data.link)
        DispatchQueue.global().async {
            if let url = url, let data = try? Data(contentsOf: url) {
 
                DispatchQueue.main.async {
                    cell.imageView.image = UIImage(data: data)
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let selectedMarket else { return UICollectionReusableView() }
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: DetailHeaderCell.self), for: indexPath) as? DetailHeaderCell else { return UICollectionReusableView() }
            header.marketTitle.text = selectedMarket.marketName
            header.marketType.text = selectedMarket.marketType
            header.marketCycle.text = selectedMarket.marketOpenCycle
            header.loadAddress.text = "도로명 주소 : \(selectedMarket.loadNameAddress ?? "도로명 주소 없음")"
            header.famousProducts.text = "품목 : \(selectedMarket.popularProducts ?? "주력상품 없음")"
            header.phoneNumber.text = "전화번호 : \(selectedMarket.phoneNumber ?? "전화번호 없음")"
            return header
        } else {
            return UICollectionReusableView()
        }
    }
}

extension DetailViewController {
    func sheetPresent() {
        if let sheetPresentationController {
            sheetPresentationController.detents = [.medium(), .large()]
            // dim 처리를 하지 않기 때문에 유저 인터렉션에 반응할 수 있음
            sheetPresentationController.largestUndimmedDetentIdentifier = .medium
            // grabber 설정
            sheetPresentationController.prefersGrabberVisible = true
            // 코너 주기
            sheetPresentationController.preferredCornerRadius = 20
        }
    }
}
