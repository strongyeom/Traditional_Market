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
      //  view.backgroundColor = UIColor.bgViewColor()
//        view.layer.cornerRadius = 12
//        view.layer.borderColor = UIColor.lightGray.cgColor
//        view.layer.borderWidth = 1
//        view.clipsToBounds = true
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
            return view
        }()
    
    let isLikeCountLabel = {
       let view = UILabel()
        view.text = "사진 저장"
        //view.sizeThatFits(CGSize(width: 40, height: 40))
        view.font = UIFont.systemFont(ofSize: 15)
        view.isUserInteractionEnabled = true
        view.textColor = .systemBlue
        view.numberOfLines = 2
        view.textAlignment = .center
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
      //  isLikeButton.configureImagebtn(image: "savedBtn")
    }
    
    override func configureView() {
        self.addSubview(bgView)
        isLikeButton.addSubview(isLikeCountLabel)
        [marketTitle, isLikeButton, marketType, marketCycle, betweenLineView, stackView, separateView].forEach {
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
        
        isLikeButton.snp.makeConstraints { make in
            make.top.equalTo(marketTitle)
            make.trailing.equalToSuperview().inset(10)
            make.size.equalTo(40)
            
        }
        
        isLikeCountLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        marketType.snp.makeConstraints { make in
            make.top.equalTo(marketTitle.snp.bottom).offset(3)
            make.leading.equalTo(marketTitle)
        }
        
        betweenLineView.snp.makeConstraints { make in
            make.leading.equalTo(marketType.snp.trailing).offset(6)
            make.verticalEdges.equalTo(marketType).inset(9)
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
        }) {  //  view.setImage(UIImage(systemName: "star"), for: .normal)
            isLikeButton.setImage(UIImage(named: "savedBtn"), for: .normal)
            isLikeCountLabel.text = ""
        } else {
            //isLikeButton.setImage(UIImage(named: "basicBtn"), for: .normal)
            isLikeButton.setImage(UIImage(named: "basicBtn"), for: .normal)
            isLikeCountLabel.text = ""
        }
    }
    
}
