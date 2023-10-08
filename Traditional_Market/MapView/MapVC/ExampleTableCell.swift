//
//  ExampleTableCell.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/08.
//

import UIKit

class ExampleTableCell : UITableViewCell {
    
    let exampleText = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(exampleText)
        exampleText.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
