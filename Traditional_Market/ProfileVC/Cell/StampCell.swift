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
    
//    let label = {
//       let view = UILabel()
//        view.text = "그리드이빈다."
//        return view
//    }()
    
    override func configureView() {
        contentView.addSubview(stampImage)
       // contentView.addSubview(label)
       // label.backgroundColor = .green
    }
    
    override func setConstraints() {
        stampImage.backgroundColor = .gray
        stampImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
//        label.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
    }
    
}
