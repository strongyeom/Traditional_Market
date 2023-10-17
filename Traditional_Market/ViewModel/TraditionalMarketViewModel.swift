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
    
    
    // mapViewRange 축척 안에 포함되는 어노테이션
    lazy var rangeFilterAnnoation = Observable(realmManager.fetch())

    var selectedMarket: Observable<TraditionalMarketRealm> = Observable(TraditionalMarketRealm(marketName: "", marketType: "", loadNameAddress: "", address: "", marketOpenCycle: "", publicToilet: "", latitude: "", longitude: "", popularProducts: "", phoneNumber: ""))

    // 내 위치 불러오기
    var startLocation = Observable(CLLocationCoordinate2D())
    
    // 내 반경에 추가되는 어노테이션들
    var addedAnnotation = Observable<[MKAnnotation]>([])
    
    // 내 위치 "버튼"을 눌렀을때 Bool 값 변수, stop or start 설정
    var isCurrentLocation = Observable(false)

    // MARK: - Method
    
    // 축척에 보이것들만 어노테이션 가져오기
    func mapScaleFilterAnnotations(minLati: Double, maxLati: Double, minLong: Double, maxLong: Double) {
        self.rangeFilterAnnoation.value = realmManager.mapViewRangeFilterAnnotations(minLati: minLati, maxLati: maxLati, minLong: minLong, maxLong: maxLong)
    }
    

    // 내 위치 버튼일 눌렀을때 true, false인지 변환해주는 메서드
    func myLocationClickedBtnIsCurrent(isSelected: Bool = false) {
        isCurrentLocation.value = isSelected
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

}
