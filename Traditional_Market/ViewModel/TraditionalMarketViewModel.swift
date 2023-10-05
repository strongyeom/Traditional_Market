//
//  TraditionalMarketViewModel.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/27.
//

import Foundation
import CoreLocation

class TraditionalMarketViewModel {
    
    let realmManager = RealmManager()
    
    var naverImageList: Observable<NaverMarketImage> = Observable(NaverMarketImage(lastBuildDate: "", total: 0, start: 0, display: 0, items: []))
    
    var selectedMarket: Observable<TraditionalMarketRealm> = Observable(TraditionalMarketRealm(marketName: "", marketType: "", loadNameAddress: "", address: "", marketOpenCycle: "", publicToilet: "", latitude: "", longitude: "", popularProducts: "", phoneNumber: ""))
    
    lazy var favoriteMarket = Observable(realmManager.allOfFavoriteRealmCount())
    
    // 선택된 전통시장 정보
    func selectedMarketInfomation(location: CLLocationCoordinate2D) -> TraditionalMarketRealm {
        
        // MARK: - 화천재래시장 , 태백시장 클릭시 에러 발생 해결해야 함
        selectedMarket.value = realmManager.selectedCity(location: location).first!
        return selectedMarket.value
    }
    
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
