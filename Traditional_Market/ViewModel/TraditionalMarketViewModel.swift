//
//  TraditionalMarketViewModel.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/27.
//

import Foundation
import CoreLocation
import MapKit

class TraditionalMarketViewModel {
    
    
    // MARK: - Properties
    let realmManager = RealmManager()
    
    var naverImageList: Observable<NaverMarketImage> = Observable(NaverMarketImage(lastBuildDate: "", total: 0, start: 0, display: 0, items: []))
    
    var selectedMarket: Observable<TraditionalMarketRealm> = Observable(TraditionalMarketRealm(marketName: "", marketType: "", loadNameAddress: "", address: "", marketOpenCycle: "", publicToilet: "", latitude: "", longitude: "", popularProducts: "", phoneNumber: ""))
    
    // 좋아하는 전통시장 리스트
    lazy var myFavoriteMarketList =  Observable(realmManager.allOfFavoriteRealmCount())
    
    // 내 위치 불러오기
    var startLocation = Observable(CLLocationCoordinate2D())
    
    // 내 반경에 추가되는 어노테이션들
    var addedAnnotation = Observable<[MKAnnotation]>([])
    
    // 내 위치 "버튼"을 눌렀을때 Bool 값 변수
    var isCurrentLocation = Observable(false)
    
    
    
    
    
    // MARK: - Method
    
    // 내 위치 버튼일 눌렀을때 true, false인지 변환해주는 메서드
    func myLocationClickedBtnIsCurrent() {
        isCurrentLocation.value = false
    }
    
    // MapView반경에 추가되는 어노테이션
    func mapViewRangeAddedAnnotation(annotation: MKAnnotation) {
        addedAnnotation.value.append(annotation)
    }
    
    
    // 시작 위치
    func startLocationFetch(location: CLLocationCoordinate2D) {
        startLocation.value = location
    }
    
    
    // 선택된 전통시장 정보
    func selectedMarketInfomation(location: CLLocationCoordinate2D) -> TraditionalMarketRealm {
        
        if let selectedCity = realmManager.selectedCity(location: location).first {
            selectedMarket.value = selectedCity
        } else {
            print("선택한 전통시장 에러 발생...")
        }
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
    
    func myFavoriteMarketSelectedRemove(market: FavoriteTable) {
        realmManager.selectedRemoveData(market: market)
    }
}
