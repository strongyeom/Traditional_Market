//
//  CityCell.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/29.
//

import UIKit

class CityCell : UICollectionViewCell {
    
    let cityView = UIView()
    let label = {
       let view = UILabel()
        view.text = "안녕하세요"
        return view
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
        contentView.addSubview(cityView)
        contentView.addSubview(label)
    }
    
    func setConstraints() {
        cityView.backgroundColor = .yellow
        cityView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(50)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(cityView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(cityView)
        }
    }
    
}
