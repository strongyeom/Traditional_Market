//
//  ClusterAnnotationView.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/11.
//

import MapKit
import UIKit

class ClusterAnnotationView: MKAnnotationView {
    
    let cluserImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "checkStamp")
        return view
    }()
    
    // MARK: Initialization
    private let countLabel = {
       let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 13, weight: .medium)
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
        self.addSubview(cluserImageView)
        cluserImageView.addSubview(countLabel)
    }
    
    func setConstraints() {
        
        cluserImageView.snp.makeConstraints { make in
            make.size.equalTo(70)
        }
        
        countLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        if let cluster = annotation as? MKClusterAnnotation {
            countLabel.text = cluster.memberAnnotations.count < 100 ? "\(cluster.memberAnnotations.count)" : "99+"
        }
    }
}
