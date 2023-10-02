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

    let currentLocationButton = {
       let view = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
        let image = UIImage(systemName: "play.circle", withConfiguration: imageConfig)
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
    }
    
    @objc func currentBtnClicked(_ sender: UIButton) {
        sender.isSelected.toggle()
        let isCurrent = sender.isSelected
        
        currentLocationButton.tintColor = isCurrent ? .systemBlue : .red
        
        completion?(isCurrent)
    }
    
    override func setConstraints() {
        mapBaseView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        
//        stackView.snp.makeConstraints { make in
//            make.top.leading.equalTo(self.safeAreaLayoutGuide).inset(10)
//        }
        
        currentLocationButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.bottom.trailing.equalToSuperview().inset(50)
        }
    }
}
