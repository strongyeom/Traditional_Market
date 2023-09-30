//
//  DetailHeaderCell.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/29.
//

import UIKit

class DetailHeaderCell : UICollectionReusableView {
    
    let view = UIView()
    
    
    let marketTitle = {
       let view = UILabel()
        view.font = .systemFont(ofSize: 25, weight: .medium)
        view.textAlignment = .left
        return view
    }()
    
    let marketType = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 13)
        return view
    }()
    
    let betweenLineView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let marketCycle = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 13)
        view.textColor = .lightGray
        return view
    }()
    
    let loadAddress = {
       let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        return view
    }()
    
    let famousProducts = {
       let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        view.numberOfLines = 2
        return view
    }()
    
    let phoneNumber = {
       let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        return view
    }()
    
    lazy var stackView = {
        let stack = UIStackView(arrangedSubviews: [loadAddress, famousProducts, phoneNumber])
        stack.axis = .vertical
        stack.spacing = 6
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
        self.addSubview(view)
        [marketTitle, marketType, marketCycle, betweenLineView, stackView].forEach {
            view.addSubview($0)
        }
    }
    
    func setConstraints() {
        view.backgroundColor = .yellow
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        marketTitle.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(13)
        }
        
        marketType.snp.makeConstraints { make in
            make.top.equalTo(marketTitle.snp.bottom).offset(3)
            make.leading.equalTo(marketTitle)
        }
        
        betweenLineView.snp.makeConstraints { make in
            make.leading.equalTo(marketType.snp.trailing).offset(5)
            make.verticalEdges.equalTo(marketType)
            make.width.equalTo(1)
        }
    
        marketCycle.snp.makeConstraints { make in
            make.leading.equalTo(betweenLineView.snp.trailing).offset(5)
            make.top.equalTo(marketType)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(marketType.snp.bottom).offset(8)
            make.leading.equalTo(marketType)
            make.trailing.equalToSuperview().inset(10)
        }
        
        
        
    }
    
}
