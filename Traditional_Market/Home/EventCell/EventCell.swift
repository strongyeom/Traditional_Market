//
//  EventCell.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/11/01.
//

import UIKit
import SnapKit
import Kingfisher


class EventCell: UICollectionViewCell {

    let eventImageView = UIImageView()
    
    let exampleText = {
       let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(eventImageView)
        eventImageView.addSubview(exampleText)
        
        eventImageView.backgroundColor = .yellow
        eventImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        exampleText.textColor = .white
        exampleText.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configureUI(data: ExampleModel) {
        self.exampleText.text = data.marketName
        MarketAPIManager.shared.requestNaverImage(search: data.marketName) { response in
            let aa = response.items.first?.thumbnail
            let url = URL(string: aa!)!
            self.eventImageView.kf.setImage(with: url)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

