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
      //  view.contentMode = .scaleAspectFill
        view.backgroundColor = .yellow
        return view
    }()
    
    let popDescription = {
        let view = UILabel()
        view.numberOfLines = 0
        return view
    }()
    
    let marketName = UILabel()
    
    
    
    override func configureView() {
        [thumbnailImage, popDescription, marketName].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        thumbnailImage.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(300)
        }
        
        marketName.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImage.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(thumbnailImage)
        }
        
        popDescription.snp.makeConstraints { make in
            make.top.equalTo(marketName.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(thumbnailImage)
        }
    }
    
    func configureUI(marketInfo: ExampleModel?, marketDescription: TenSelectedMarketSection?, imageUrl: URL?) {
        
        guard let marketInfo = marketInfo,
              let marketDescription = marketDescription,
        let imageUrl = imageUrl
        else { return }
        
        self.thumbnailImage.kf.setImage(with: imageUrl)
        self.marketName.text = marketInfo.marketName
        self.popDescription.text = marketDescription.description
    }
}
