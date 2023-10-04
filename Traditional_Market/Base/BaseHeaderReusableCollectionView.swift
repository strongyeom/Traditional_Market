//
//  BaseHeaderReusableCollectionView.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/04.
//

import UIKit


class BaseHeaderReusableCollectionView : UICollectionReusableView {
    
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
