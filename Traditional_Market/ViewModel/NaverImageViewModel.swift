//
//  NaverImageViewModel.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/17.
//

import Foundation

class NaverImageViewModel {
    
    var naverImageList: Observable<NaverMarketImage> = Observable(NaverMarketImage(lastBuildDate: "", total: 0, start: 0, display: 0, items: []))
    
    // 네이버 API 통신
    // 시장 title 이용해서 Naver이미지 API 사용
    func requestImage(search: TraditionalMarketRealm) {
        MarketAPIManager.shared.requestNaverImage(search: search.marketName) { response in
            DispatchQueue.main.async {
                self.naverImageList.value.items.append(contentsOf: response.items)
            }
        }
    }
}
