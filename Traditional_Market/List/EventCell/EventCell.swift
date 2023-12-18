//
//  EventCell.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/11/01.
//

import UIKit
import SnapKit
import Kingfisher
import SkeletonView

class EventCell: UICollectionViewCell {

    let eventImageView = {
       let view = UIImageView()
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .continuous
        view.isSkeletonable = true
        view.clipsToBounds = true
        return view
    }()
    
    let marketName = {
       let view = UILabel()
        view.numberOfLines = 0
        view.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        view.textAlignment = .center
        view.isSkeletonable = true
        return view
    }()
//
    var data: ExampleModel? {
        didSet {
            configureUI(data: data)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraints()
        
        
        isSkeletonable = true
        // contentView 의 하위 뷰에 적용 
        contentView.isSkeletonable = true
    }
    
    func configure() {
        self.addSubview(eventImageView)
        eventImageView.addSubview(marketName)
        startSkeletonAnimation()
    }
    
    func setConstraints() {
       // eventImageView.backgroundColor = .yellow
        eventImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        marketName.textColor = .white
        marketName.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    func configureUI(data: ExampleModel?) {
        guard let data else {
            return
        }
        showAnimatedGradientSkeleton()
        
        MarketAPIManager.shared.requestNaverImage(search: data.marketName) { response in
//            print("resonse.items : \(response.items)")
            
            let _ = response.items.map {
                let url = URL(string: $0.link)!
                self.eventImageView.kf.setImage(with: url)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                    self.hideSkeleton()
                    self.marketName.text = data.marketName
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.eventImageView.image = nil
        self.marketName.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

