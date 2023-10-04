//
//  ExampleCell.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/05.
//

import UIKit

class ExampleCell : UITableViewCell {
    
    let infoText = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        contentView.addSubview(infoText)
    }
    
    func setConstraints() {
        infoText.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview().inset(5)
        }
    }
    
}

