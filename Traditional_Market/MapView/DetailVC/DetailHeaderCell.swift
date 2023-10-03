//
//  DetailHeaderCell.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/29.
//

import UIKit

protocol IsLikeDelegate: AnyObject {
    func isLikeClickedEvent()
}

final class DetailHeaderCell : UICollectionReusableView {
    
    private let bgView = {
        let view = UIView()
        view.backgroundColor = UIColor.bgViewColor()
        return view
    }()
    
    
    private let marketTitle = {
       let view = UILabel()
        view.font = .systemFont(ofSize: 25, weight: .medium)
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
    
    private let isLikeButton = {
       let view = UIButton()
        view.setImage(UIImage(systemName: "star"), for: .normal)
        view.tintColor = .red
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
    
    private lazy var stackView = {
        let stack = UIStackView(arrangedSubviews: [loadAddress, famousProducts, phoneNumber])
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    weak var delegate: IsLikeDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setConstraints()
        isLikeButton.addTarget(self, action: #selector(isLikeBtnClicked(_:)), for: .touchUpInside)
    }
    
    @objc func isLikeBtnClicked(_ sender: UIButton) {
        print("즐겨찾기 버튼 눌림")
        delegate?.isLikeClickedEvent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        self.addSubview(bgView)
        [marketTitle, isLikeButton, marketType, marketCycle, betweenLineView, stackView].forEach {
            bgView.addSubview($0)
        }
    }
    
    private func setConstraints() {
        
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        marketTitle.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(10)
        }
        
        isLikeButton.snp.makeConstraints { make in
            make.verticalEdges.equalTo(marketTitle)
            make.trailing.equalToSuperview().inset(10)
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
    
    func configureCell(market: TraditionalMarketRealm) {
        self.marketTitle.text = market.marketName
        self.marketType.text = market.marketType
        self.marketCycle.text = market.marketOpenCycle
        self.loadAddress.text = "도로명 주소 : \(market.loadNameAddress ?? "도로명 주소 없음")"
        self.famousProducts.text = "품목 : \(market.popularProducts ?? "주력상품 없음")"
        self.phoneNumber.text = "전화번호 : \(market.phoneNumber ?? "전화번호 없음")"
    }
    
}
