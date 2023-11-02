//
//  PopularMarketDetailViewController.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/11/02.
//

import UIKit
import Kingfisher

class PopularMarketDetailViewController : BaseViewController {
    
    var marketDetailInfo: ExampleModel?
    
    var marketDescription: TenSelectedMarketSection?
    
    let popularView = PopularView()
    
    var imageUrl: URL? = nil
  
    override func loadView() {
        self.view = popularView
    }
     
    override func configureView() {
        super.configureView()
        print("PopularMarketDetailViewController: marketDetailInfo- \(marketDetailInfo!)")
        
//        self.popularView.thumbnailImage.kf.setImage(with: self.imageUrl!)
//        guard let marketDetailInfo = marketDetailInfo,
//              let marketDescription = marketDescription else { return }
//
//        popularView.marketName.text = marketDetailInfo.marketName
//        popularView.popDescription.text = marketDescription.description
//
        popularView.configureUI(marketInfo: marketDetailInfo, marketDescription: marketDescription, imageUrl: imageUrl)
    }
}
