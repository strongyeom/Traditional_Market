//
//  EventCell.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/11/01.
//

import UIKit
import SnapKit

class EventCell: UICollectionViewCell {
    
//    static let identifier = "EventCell"
    
    let view = UIView()
    
    let exampleText = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(view)
        view.addSubview(exampleText)
        
        view.backgroundColor = .yellow
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        exampleText.textColor = .red
        exampleText.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

