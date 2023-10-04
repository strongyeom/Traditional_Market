//
//  ListCell.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/04.
//

import UIKit

class ListCell : BaseColletionViewCell {
    let market = {
       let view = UILabel()
        view.text = "테스트 테스트"
        return view
    }()
    let accessoryImageView = UIImageView()
    let seperatorView = UIView()
    
    override func configureView() {
        [market, accessoryImageView, seperatorView].forEach {
            contentView.addSubview($0)
        }
        
        // 해당 View를 클릭했을때 그 위로 View를 띄울 수 있음 opacity를 조정할 수 있음
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
    }
    
    override func setConstraints() {
        market.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(10)
            make.bottom.equalTo(seperatorView.snp.top).inset(9)
        }
        
        let rtl = effectiveUserInterfaceLayoutDirection == .rightToLeft
        let chevronImageName = rtl ? "chevron.left" : "chevron.right"
        let chevronImage = UIImage(systemName: chevronImageName)
        accessoryImageView.image = chevronImage
        accessoryImageView.tintColor = UIColor.lightGray.withAlphaComponent(0.7)
        
        accessoryImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(market.snp.trailing).inset(10)
            make.verticalEdges.equalTo(market)
        }
        
        seperatorView.snp.makeConstraints { make in
            make.leading.equalTo(market)
            make.trailing.equalTo(accessoryImageView)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
}
