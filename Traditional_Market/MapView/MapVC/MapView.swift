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
        City(imageName: "Seoul"),
        City(imageName: "Gyeonggi-do"),
        City(imageName: "Gangwon-do"),
        City(imageName: "Chungcheongbuk-do"),
        City(imageName: "Chungcheongnam-do"),
        City(imageName: "Gyeongsangbuk-do"),
        City(imageName: "Gyeongsangnam-do"),
        City(imageName: "Jeollabuk-do"),
        City(imageName: "Jeollanam-do"),
        City(imageName: "Jeju-do")
    ]
    
    func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let spacing: CGFloat = 20
        let width = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: width / 5, height: width / 5)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        return layout
    }
    

    

    let currentLocationButton = {
       let view = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
        let image = UIImage(systemName: "paperplane.circle", withConfiguration: imageConfig)
        view.setTitle("", for: .normal)
        view.setImage(image, for: .normal)
        return view
    }()
    
    var mapBaseView = {
        let view = MKMapView()
        view.showsUserLocation = true
        view.userTrackingMode = .follow
        view.cameraZoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 1000000)
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
            make.edges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(80)
        }
        
        currentLocationButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.bottom.trailing.equalToSuperview().inset(50)
        }
    }
}
