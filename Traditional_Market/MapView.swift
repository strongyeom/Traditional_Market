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
    
    var mapView = MKMapView()
    
    
    lazy var stackView = {
        let stack = UIStackView(arrangedSubviews: [button1, button2])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()
    
    
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
        self.addSubview(mapView)
        mapView.addSubview(stackView)
    }
    
    func setConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.leading.equalTo(self.safeAreaLayoutGuide).inset(10)
        }
    }
}
