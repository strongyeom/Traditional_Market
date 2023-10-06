//
//  CityCell.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/29.
//

import UIKit

class CityCell : BaseColletionViewCell {
    
    let imageView = {
        let view = UIImageView()
        return view
    }()
    
    let baseView = {
       let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    
    let localName = {
        let view = UILabel()
        // View 사이즈에 Label크기 자동으로 맞춤
        view.adjustsFontSizeToFitWidth = true
        view.clipsToBounds = true
        return view
    }()
    
    override func configureView() {
        contentView.addSubview(baseView)
        baseView.addSubview(imageView)
        baseView.addSubview(localName)
    }
    
    override func setConstraints() {
        
        baseView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
       
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.size.equalTo(28)
            make.centerY.equalToSuperview()
        }
        
        localName.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalTo(imageView)
        }
        
    }
}
