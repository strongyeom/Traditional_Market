//
//  ListCell.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/04.
//

import UIKit

class ListCell : UITableViewCell {
    
    let marketLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        contentView.addSubview(marketLabel)
    }
    
    func setConstraints() {
        marketLabel.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview().inset(5)
           
        }
    }
    
}
