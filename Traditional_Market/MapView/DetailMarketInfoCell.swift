//
//  DetailCell.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/29.
//

import UIKit

class DetailMarketInfoCell : UICollectionViewCell {
    
    let marketName = {
       let view = UILabel()
        view.text = "123123"
        view.font = .systemFont(ofSize: 20, weight: .medium)
        return view
    }()
    
    let loadAddress = {
       let view = UILabel()
        view.text = "123123"
        view.font = .systemFont(ofSize: 14)
        return view
    }()
    
    let address = {
       let view = UILabel()
        view.text = "123123"
        view.font = .systemFont(ofSize: 14)
        return view
    }()
    
    let phoneNumber = {
       let view = UILabel()
        view.text = "123123"
        view.font = .systemFont(ofSize: 14)
        return view
    }()
    
    let marketCycle = {
       let view = UILabel()
        view.text = "123123"
        view.font = .systemFont(ofSize: 14)
        return view
    }()
    
    lazy var stackView = {
        let stack = UIStackView(arrangedSubviews: [marketName, loadAddress, address, phoneNumber, marketCycle])
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        contentView.addSubview(stackView)
    }
    
    func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
