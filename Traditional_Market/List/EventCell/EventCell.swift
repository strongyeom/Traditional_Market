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

    let eventImageView = {
       let view = UIImageView()
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .continuous
        view.clipsToBounds = true
        return view
    }()
    
    let exampleText = {
       let view = UILabel()
        view.numberOfLines = 0
        view.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        view.textAlignment = .center
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraints()
      
    }
    
    func configure() {
        self.addSubview(eventImageView)
        eventImageView.addSubview(exampleText)
    }
    
    func setConstraints() {
        eventImageView.backgroundColor = .yellow
        eventImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        exampleText.textColor = .white
        exampleText.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    func configureUI(data: ExampleModel) {
        self.exampleText.text = data.marketName
        MarketAPIManager.shared.requestNaverImage(search: data.marketName) { response in
            print("resonse.items : \(response.items)")
            let aa = response.items.first?.thumbnail
            let url = URL(string: aa ?? "https://images.unsplash.com/photo-1682686580036-b5e25932ce9a?auto=format&fit=crop&q=80&w=2875&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")!
            self.eventImageView.kf.setImage(with: url)

        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.eventImageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

