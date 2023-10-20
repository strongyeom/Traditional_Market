//
//  ClusterAnnotationView.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/11.
//

import MapKit
import UIKit

class ClusterAnnotationView: MKAnnotationView {
    
    let clusterImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "checkStamp")
        return view
    }()
    
    
    let countLabelvBg = {
       let view = UIView()
        view.backgroundColor = UIColor(named: "brandColor")
        return view
    }()
    
    // MARK: Initialization
    private let countLabel = {
       let view = UILabel()
        view.textColor = UIColor(named: "clusterCountColor")
        view.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        return view
    }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        displayPriority = .defaultHigh
                collisionMode = .circle

                frame = CGRect(x: 0, y: 0, width: 40, height: 50)
                centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        configureView()
        setConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureView() {
        self.addSubview(clusterImageView)
        self.addSubview(countLabelvBg)
        countLabelvBg.addSubview(countLabel)
        
       // clusterImageView.addSubview(countLabelvBg)
    }
    
    func setConstraints() {
        
        clusterImageView.snp.makeConstraints { make in
            make.size.equalTo(50)
        }
//
//        countLabel.snp.makeConstraints { make in
//            make.leading.equalTo(clusterImageView.snp.trailing)
//            make.top.equalTo(clusterImageView)
//        }
        
        
        
        countLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        countLabelvBg.snp.makeConstraints { make in
            make.leading.equalTo(clusterImageView.snp.trailing).inset(3)
            make.top.equalTo(clusterImageView).offset(-15)
            make.size.equalTo(30)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.countLabelvBg.layer.cornerRadius = self.countLabelvBg.frame.width / 2
        self.countLabelvBg.layer.cornerCurve = .circular
        self.countLabelvBg.clipsToBounds = true
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        if let cluster = annotation as? MKClusterAnnotation {
            countLabel.text = cluster.memberAnnotations.count < 100 ? "\(cluster.memberAnnotations.count)" : "99+"
        }
    }
}
