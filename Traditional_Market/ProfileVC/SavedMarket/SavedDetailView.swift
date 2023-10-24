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
    
    let memoTextView = {
       let view = UITextView()
        view.layer.cornerRadius = 12
        view.layer.cornerCurve = .continuous
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        view.isEditable = false
        view.backgroundColor = .systemGray
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
    
    private let memoLabel = {
       let view = UILabel()
        view.text = "메모 : "
        view.font = .systemFont(ofSize: 14)
        return view
    }()
    
    
    override func configureView() {
        [savedImageView, marketTitle, marketCycle, betweenLineView, marketType, stackView, memoLabel, memoTextView].forEach {
            self.addSubview($0)
        }
        self.backgroundColor = UIColor(named: "blackAndWhiteColor")
    }
    
    override func setConstraints() {
        
        savedImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(savedImageView.snp.width)
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
        
        memoLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(stackView)
            make.top.equalTo(stackView.snp.bottom).offset(23)
        }
        
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(memoLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(memoLabel)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    func configureSavedView(market: FavoriteTable) {
        marketTitle.text = market.marketName
        marketType.text = market.marketType
        marketCycle.text = market.marketOpenCycle
        loadAddress.text = "도로명주소 : \(market.loadNameAddress ?? "")"
        famousProducts.text = "품목 : \(market.popularProducts ?? "")"
        phoneNumber.text =  "전화번호 : \(market.phoneNumber ?? "")"
        memoTextView.text = market.memo ?? ""
    }
    
   
    
}
