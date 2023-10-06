//
//  MapView.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/26.
//

import UIKit
import MapKit
import SnapKit

class MapView : BaseView {
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    // 각 City 배열
    let cityList: [City] = [
        City(imageName: "basicStamp", localname: "상설장"),
        City(imageName: "checkStamp", localname: "5일장"),
        City(imageName: "Seoul", localname: "서울특별시"),
        City(imageName: "Gyeonggi-do", localname: "경기도"),
        City(imageName: "Gangwon-do", localname: "강원도"),
        City(imageName: "Chungcheongbuk-do", localname: "충청북도"),
        City(imageName: "Chungcheongnam-do", localname: "충청남도"),
        City(imageName: "Gyeongsangbuk-do", localname: "경상북도"),
        City(imageName: "Gyeongsangnam-do", localname: "경상남도"),
        City(imageName: "Jeollabuk-do", localname: "전라북도"),
        City(imageName: "Jeollanam-do", localname: "전라남도"),
        City(imageName: "Jeju-do", localname: "제주도")
    ]
    
    func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let spacing: CGFloat = 10
        let width = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: width / 4, height: width / 6)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        return layout
    }

    let currentLocationButton = {
       let view = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
        let image = UIImage(systemName: "location.circle", withConfiguration: imageConfig)
        view.setTitle("", for: .normal)
        view.setImage(image, for: .normal)
        return view
    }()
    
    var mapBaseView = {
        let view = MKMapView()
        view.showsUserLocation = true
        view.userTrackingMode = .follow
        view.cameraZoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
        return view
    }()

    var completion: ((Bool) -> Void)?
 
    override func configureView() {
        self.addSubview(mapBaseView)
        mapBaseView.addSubview(currentLocationButton)
        self.currentLocationButton.addTarget(self, action: #selector(currentBtnClicked), for: .touchUpInside)
        configureCity()
    }
    
    func configureCity() {
        mapBaseView.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CityCell.self, forCellWithReuseIdentifier: String(describing: CityCell.self))
        
    }
    
    @objc func currentBtnClicked(_ sender: UIButton) {
        sender.isSelected.toggle()
        let isCurrent = sender.isSelected
        
        currentLocationButton.tintColor = isCurrent ? .systemBlue : .black
        
        completion?(isCurrent)
    }
    
    override func setConstraints() {
        
        mapBaseView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
           // make.edges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(70)
        }
        
        currentLocationButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.trailing.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(15)
            
        }
    }
}
