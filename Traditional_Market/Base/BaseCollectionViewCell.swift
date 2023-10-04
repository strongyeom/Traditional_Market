//
//  BaseCollectionViewCell.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/04.
//

import UIKit

class BaseColletionViewCell : UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        
    }
    
    func setConstraints() {
        
    }
}
