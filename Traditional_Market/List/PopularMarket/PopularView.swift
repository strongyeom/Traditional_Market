//
//  PopularView.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/11/02.
//

import UIKit
import SkeletonView

class PopularView : BaseView {
    
    let scrollView = UIScrollView()
    let baseContentView = UIView()
    
    let thumbnailImage = {
       let view = UIImageView()
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .continuous
        view.isSkeletonable = true
        view.clipsToBounds = true
        return view
    }()
    
    let marketName = {
       let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        view.isSkeletonable = true
        return view
    }()
    
    let address = {
       let view = UILabel()
        view.textColor = .lightGray
        view.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        view.isSkeletonable = true
        return view
    }()
    
    let telePhone = {
       let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        view.isSkeletonable = true
        return view
    }()
    
    
    let descriptionTitle = {
       let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 15, weight: .bold)
//        view.text = "상세 설명"
        return view
    }()
    
    let popDescription = {
        let view = UILabel()
        view.numberOfLines = 0
        view.isSkeletonable = true
        return view
    }()
    

    
    override func configureView() {
        
        self.addSubview(scrollView)
        
        [thumbnailImage, marketName, address, telePhone].forEach {
            self.addSubview($0)
        }
        
        scrollView.addSubview(baseContentView)
        
        [descriptionTitle, popDescription].forEach {
            baseContentView.addSubview($0)
        }
        
        isSkeletonable = true
    }
    
    override func setConstraints() {
        
      
       
        thumbnailImage.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(300)
        }
        
        marketName.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImage.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(thumbnailImage)
        }
        
        address.snp.makeConstraints { make in
            make.top.equalTo(marketName.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(marketName)
        }
        
        telePhone.snp.makeConstraints { make in
            make.top.equalTo(address.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(marketName)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(telePhone.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(thumbnailImage)
            make.bottom.equalToSuperview()
        }
        
        descriptionTitle.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
        }
        
        popDescription.snp.makeConstraints { make in
            make.top.equalTo(descriptionTitle.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(thumbnailImage)
            make.bottom.equalToSuperview()
        }
        
        baseContentView.snp.makeConstraints { make in
            make.centerX.verticalEdges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
    }
    
    func configureUI(marketInfo: ExampleModel, marketDescription: TenSelectedMarketSection?) {
        
        self.marketName.text = marketInfo.marketName
        guard let marketDescription else { return }
        self.popDescription.text = "상세 설명 : " + marketDescription.description
        self.address.text = "주소 : " + (marketInfo.loadNameAddress ?? "")
        self.telePhone.text = "전화번호 : " + (marketInfo.phoneNumber ?? "")
    }
    
    func detailFestivalConfigureUI(data: ContentIDBaseItem?) {
        guard let data else { return }
        showAnimatedGradientSkeleton()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            self.hideSkeleton()
            print("PopularView - \(data)")
            self.descriptionTitle.text = "상세 설명"
            self.marketName.text = data.title
            self.address.text = "주소 : " + (data.addr1 ?? "")
            self.telePhone.text = "전화번호 : " + (data.tel ?? "")
            self.popDescription.text = (data.overview ?? "").replacingOccurrences(of: "<br>", with: "")
        }
        
      
    }
}
