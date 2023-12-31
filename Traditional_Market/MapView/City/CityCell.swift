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
        view.layer.cornerCurve = .continuous
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        return view
    }()
    
    
    let localName = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 10)
        view.textAlignment = .center
        return view
    }()
    
    lazy var stackView = {
        let stack = UIStackView(arrangedSubviews: [imageView, localName])
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()
    
    override func configureView() {
        contentView.addSubview(baseView)
        baseView.addSubview(stackView)
        
    }
    
    override func setConstraints() {
        
        baseView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview()
            
        }
       
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(self.imageView.snp.width)
            
        }
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().inset(5)
          //  make.top.equalToSuperview().inset(10)
        }
    }
    
}
