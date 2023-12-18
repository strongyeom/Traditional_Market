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
    
    private let isLikeImage = {
       let view = UIImageView()
        view.tintColor = .red
        view.isHidden = true
        return view
    }()
 
    let isLikeButton = {
       let view = UIButton()
        var config = UIButton.Configuration.bordered()
        config.title = "장터\n기록"

        config.baseBackgroundColor = .clear
        config.background.strokeColor = .systemBlue
        config.background.strokeWidth = 1.0
        config.buttonSize = .medium
        view.configuration = config
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
    
    let separateView = {
       let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    weak var delegate: IsLikeDelegate?
    
    var completion: (() -> Void)?
  
    @objc func isLikeBtnClicked(_ sender: UIButton) {
        print("즐겨찾기 버튼 눌림")
        delegate?.isLikeClickedEvent()
    }
    
    override func configureView() {
        self.addSubview(bgView)
        [marketTitle, isLikeButton, marketType, marketCycle, betweenLineView, stackView, separateView, isLikeImage].forEach {
            bgView.addSubview($0)
        }
        isLikeButton.addTarget(self, action: #selector(isLikeBtnClicked(_:)), for: .touchUpInside)
    }
    
    override func setConstraints() {
        
        bgView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview().inset(10)
            make.top.equalTo(self.safeAreaLayoutGuide).inset(25)
        }
        
        
        marketTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(3)
        }
        
        isLikeImage.snp.makeConstraints { make in
            make.leading.equalTo(marketTitle.snp.trailing).offset(13)
            make.centerY.equalTo(marketTitle)
            make.size.equalTo(25)
        }
        
        isLikeButton.snp.makeConstraints { make in
            make.centerY.equalTo(isLikeImage)
            make.trailing.equalToSuperview().inset(10)
//            make.size.equalTo(40)
            
        }
        
        marketType.snp.makeConstraints { make in
            make.top.equalTo(marketTitle.snp.bottom).offset(3)
            make.leading.equalTo(marketTitle)
        }
        
        betweenLineView.snp.makeConstraints { make in
            make.leading.equalTo(marketType.snp.trailing).offset(6)
            make.verticalEdges.equalTo(marketType).inset(4)
            make.width.equalTo(1)
        }
    
        marketCycle.snp.makeConstraints { make in
            make.leading.equalTo(betweenLineView.snp.trailing).offset(6)
            make.centerY.equalTo(marketType)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(marketType.snp.bottom).offset(3)
            make.horizontalEdges.bottom.equalToSuperview().inset(10)
        }
        
        separateView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview()
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
        }) {
            isLikeImage.image = UIImage(named: "savedImage")
            isLikeImage.isHidden = false
        }
    }
    
}
