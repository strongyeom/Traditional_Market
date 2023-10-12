//
//  DetailHeaderCell.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/29.
//

import UIKit
import RealmSwift

protocol IsLikeDelegate: AnyObject {
    func isLikeClickedEvent()
}

final class DetailHeaderCell : BaseHeaderReusableCollectionView {
    
    let realmManager = RealmManager()
    
    private let bgView = {
        let view = UIView()
        view.backgroundColor = UIColor.bgViewColor()
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private let dismissBtn = {
       let view = UIButton()
        view.setTitle("닫기", for: .normal)
        view.setTitleColor(UIColor.systemBlue, for: .normal)
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
       // view.setImage(UIImage(systemName: "star"), for: .normal)
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
    
    var completion: (() -> Void)?
  
    @objc func isLikeBtnClicked(_ sender: UIButton) {
        print("즐겨찾기 버튼 눌림")
        delegate?.isLikeClickedEvent()
    }
    
    override func configureView() {
        self.addSubview(bgView)
        self.addSubview(dismissBtn)
        [marketTitle, isLikeButton, marketType, marketCycle, betweenLineView, stackView].forEach {
            bgView.addSubview($0)
        }
        isLikeButton.addTarget(self, action: #selector(isLikeBtnClicked(_:)), for: .touchUpInside)
        dismissBtn.addTarget(self, action: #selector(dissmissBtn(_:)), for: .touchUpInside)
    }
    
    @objc func dissmissBtn(_ sender: UIButton) {
        completion?()
    }
    
    override func setConstraints() {
        
        dismissBtn.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(5)
            make.trailing.equalTo(bgView).inset(4)
        }
        
        bgView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview().inset(10)
            make.top.equalTo(dismissBtn.snp.bottom)
        }
        
        
        marketTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(10)
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
        
        let favoriteTable = realmManager.allOfFavoriteRealmCount()

        if favoriteTable.contains(where: {
            $0.marketName == market.marketName
        }) {  //  view.setImage(UIImage(systemName: "star"), for: .normal)
            isLikeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            isLikeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
}
