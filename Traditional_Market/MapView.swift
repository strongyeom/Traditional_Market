//
//  MapView.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/26.
//

import UIKit
import MapKit
import SnapKit

class MapView : UIView {
    
    let button1 = {
       let view = UIButton()
        view.settingButtonLayer(title: "상설장")
        return view
    }()
    
    let button2 = {
       let view = UIButton()
        view.settingButtonLayer(title: "5일장")
        return view
    }()
    
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
    
    
    lazy var stackView = {
        let stack = UIStackView(arrangedSubviews: [button1, button2])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()
    
    var completion: ((Bool) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        //self.addSubview(searchBar)
        self.addSubview(mapBaseView)
        mapBaseView.addSubview(stackView)
        mapBaseView.addSubview(currentLocationButton)
        self.currentLocationButton.addTarget(self, action: #selector(currentBtnClicked), for: .touchUpInside)
    }
    
    @objc func currentBtnClicked(_ sender: UIButton) {
        sender.isSelected.toggle()
        let isCurrent = sender.isSelected
        
        currentLocationButton.tintColor = isCurrent ? .systemBlue : .red
        
        completion?(isCurrent)
    }
    
    func setConstraints() {
        mapBaseView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.leading.equalTo(self.safeAreaLayoutGuide).inset(10)
        }
        
        currentLocationButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.bottom.trailing.equalToSuperview().inset(50)
        }
    }
}
