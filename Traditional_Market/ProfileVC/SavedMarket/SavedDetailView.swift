//
//  SavedDetailView.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/13.
//

import UIKit

class SavedDetailView : BaseView {
    
    
    
    let savedImageView = UIImageView()
    
    private let marketTitle = {
       let view = UILabel()
        view.font = .systemFont(ofSize: 17, weight: .medium)
        view.textAlignment = .left
        return view
    }()
    
    private let marketType = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 13)
        return view
    }()
    
    private let betweenLineView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    private let marketCycle = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 13)
        view.textColor = .lightGray
        return view
    }()
    
    private let loadAddress = {
       let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        view.numberOfLines = 2
        return view
    }()
    
    private let famousProducts = {
       let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        view.numberOfLines = 2
        return view
    }()
    
    private let phoneNumber = {
       let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        return view
    }()
    
    private let memoText = {
       let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var stackView = {
        let stack = UIStackView(arrangedSubviews: [loadAddress, famousProducts, phoneNumber])
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    
    
    override func configureView() {
        [savedImageView, marketTitle, marketCycle, betweenLineView, marketType, stackView, memoText].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        savedImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(300)
        }
        
        marketTitle.snp.makeConstraints { make in
            make.top.equalTo(savedImageView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(10)
           
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
        
        memoText.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(stackView)
         //   make.bottom.equalTo(self.safeAreaLayoutGuide).inset(10)
        }
    }
    
    func configureSavedView(market: FavoriteTable) {
        marketTitle.text = market.marketName
        marketType.text = market.marketType
        marketCycle.text = market.marketOpenCycle
        loadAddress.text = market.loadNameAddress
        famousProducts.text = market.popularProducts
        phoneNumber.text = market.phoneNumber
        memoText.text = "메모 : \(market.memo ?? "")"
    }
    
   
    
}
