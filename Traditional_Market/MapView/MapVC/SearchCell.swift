//
//  ExampleTableCell.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/08.
//

import UIKit

class SearchCell : UITableViewCell {
    
    let marketName = {
       let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return view
    }()
    
    
    let marketAddress = {
       let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 13)
        view.textColor = .lightGray
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(marketName)
        contentView.addSubview(marketAddress)
        
        marketName.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(10)
        }
        
        marketAddress.snp.makeConstraints { make in
            make.top.equalTo(marketName.snp.bottom).offset(5)
            make.leading.equalTo(marketName)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
}
