//
//  DetailCell.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/29.
//

import UIKit

final class DetailMarketInfoCell : BaseColletionViewCell {
    
    
    private let imageView = {
       let view = UIImageView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    override func configureView() {
        contentView.addSubview(imageView)
    }
    
    override func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureCell(market: NaverItem) {
        let url = URL(string: market.link)
        
        DispatchQueue.global().async {
            if let url = url, let data = try? Data(contentsOf: url) {
 
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}
