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
    
    override func loadView() {
        self.view = popularView
    }
     
    override func configureView() {
        super.configureView()
        print("PopularMarketDetailViewController: marketDetailInfo- \(marketDetailInfo!)")
        print("PopularMarketDetailViewController: descrtion - \(marketDescription?.description)")
        
//        print("PopularMarketDetailViewController: thumbnail - \(thumbnail!)")
    
        MarketAPIManager.shared.requestNaverImage(search: marketDetailInfo!.marketName) { response in
            print(response.items.first?.thumbnail)
            let aa = response.items.first?.thumbnail
            let url = URL(string: aa!)!
            self.popularView.thumbnailImage.kf.setImage(with: url)
        }
        popularView.marketName.text = marketDetailInfo?.marketName
        popularView.popDescription.text = marketDescription?.description
        
    }
}
