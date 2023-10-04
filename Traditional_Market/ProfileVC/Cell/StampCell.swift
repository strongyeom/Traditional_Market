//
//  StampCell.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/04.
//

import UIKit

class StampCell : BaseColletionViewCell {
    
    // 이미지만
    
    let stampImage = UIImageView()
    
    override func configureView() {
        contentView.addSubview(stampImage)
    }
    
    override func setConstraints() {
        stampImage.backgroundColor = .gray
        stampImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
