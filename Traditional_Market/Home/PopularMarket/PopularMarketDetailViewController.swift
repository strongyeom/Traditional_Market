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
    
    var cellDataImage: UIImage?
  
    override func loadView() {
        self.view = popularView
    }
     
    override func configureView() {
        super.configureView()
        print("PopularMarketDetailViewController: marketDetailInfo - \(marketDetailInfo!)")
        
        popularView.thumbnailImage.image = cellDataImage
        popularView.configureUI(marketInfo: marketDetailInfo, marketDescription: marketDescription)
    }
}
