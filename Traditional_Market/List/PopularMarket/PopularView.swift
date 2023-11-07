//
//  PopularView.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/11/02.
//

import UIKit

class PopularView : BaseView {
    
    let thumbnailImage = {
       let view = UIImageView()
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .continuous
        view.clipsToBounds = true
        return view
    }()
    
    let marketName = {
       let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return view
    }()
    
    let address = {
       let view = UILabel()
        view.textColor = .lightGray
        view.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        return view
    }()
    
    let telePhone = {
       let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        return view
    }()
    
    
    
    let popDescription = {
        let view = UILabel()
        view.numberOfLines = 0
        
        return view
    }()
    

    
    override func configureView() {
        [thumbnailImage, marketName, address, telePhone, popDescription].forEach {
            self.addSubview($0)
        }
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
        
        popDescription.snp.makeConstraints { make in
            make.top.equalTo(telePhone.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(thumbnailImage)
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
        print("PopularView - \(data)")
        self.marketName.text = data.title
        self.address.text = "주소 : " + (data.addr1 ?? "")
        self.telePhone.text = "전화번호 : " + (data.tel ?? "")
        self.popDescription.text = "상세 설명 : " + (data.overview ?? "").replacingOccurrences(of: "<br>", with: "")
    }
}
