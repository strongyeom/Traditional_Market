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
    
    private let popularView = PopularView()
    
    var sectionNumber: Int = 0
    
    var cellDataImage: UIImage?
    
    private var festivalDetailInfomation: ContentIDBaseItem?
    
    let group = DispatchGroup()
    
    let loadingView = {
        let view = UIActivityIndicatorView()
        view.style = .medium
        return view
    }()
  
    override func loadView() {
        self.view = popularView
    }
     
    override func configureView() {
        super.configureView()
        setNavigation()
        self.view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        guard let marketDetailInfo = marketDetailInfo else { return }
        
        if sectionNumber != 2 {
            popularView.configureUI(marketInfo: marketDetailInfo, marketDescription: marketDescription)
            popularView.thumbnailImage.image = cellDataImage
        } else {
            // 넘어온 item의 id를 기반으로 네트워크 통신 다시 하기
            // 필요한 리소스 제목, 내용, 전화번호, 좌표
            self.loadingView.startAnimating()
            group.enter()
            MarketAPIManager.shared.requestKoreFestivalContentIdBase(contentId: Int(marketDetailInfo.address!)!) { result in
                self.festivalDetailInfomation = result
                
                self.group.leave()
            }
            
            group.notify(queue: .main) {
                self.loadingView.stopAnimating()
                self.popularView.thumbnailImage.image = self.cellDataImage
                self.popularView.detailFestivalConfigureUI(data: self.festivalDetailInfomation)
            }
        }
    }
    
    func setNavigation() {
        navigationItem.title = "문화 관광 축제"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(cancelClicked))
    }
    
    @objc func cancelClicked() {
        dismiss(animated: true)
    }
}
