//
//  CityIndex.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/29.
//

import Foundation
import CoreLocation

enum CityIndex: Int {
    case everyDay = 0
    case fiveDay
    case seoul
    case gyeonggi_do
    case gangwon_do
    case chungcheongbuk_do
    case chungcheongnam_do
    case gyeongsangbuk_do
    case gyeongsangnam_do
    case jeollabuk_do
    case jeollanam_do
    case jeju_do
   
    var location: CLLocationCoordinate2D {
        switch self {
        case .everyDay:
            return CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        case .fiveDay:
            return CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        case .seoul: // 서울시청
            return CLLocationCoordinate2D(latitude: 37.566713, longitude: 126.978428)
        case .gyeonggi_do: // 경기도청
            return CLLocationCoordinate2D(latitude: 37.566713, longitude: 126.978428)
        case .gangwon_do: // 강원도청
            return CLLocationCoordinate2D(latitude: 37.884546, longitude: 127.730708)
        case .chungcheongbuk_do: // 충청북도청
            return CLLocationCoordinate2D(latitude: 36.635712, longitude: 127.491391)
        case .chungcheongnam_do: // 충청남도청
            return CLLocationCoordinate2D(latitude: 36.659482, longitude: 126.673241)
        case .gyeongsangbuk_do: // 경상북도청
            return CLLocationCoordinate2D(latitude: 36.575920, longitude: 128.505912)
        case .gyeongsangnam_do: // 경상남도청
            return CLLocationCoordinate2D(latitude: 35.237702, longitude: 128.691992)
        case .jeollabuk_do: // 전라북도청
            return CLLocationCoordinate2D(latitude: 35.820580, longitude: 127.111265)
        case .jeollanam_do: // 전라남도청
            return CLLocationCoordinate2D(latitude: 34.816245, longitude: 126.462885)
        case .jeju_do: // 제주특별자치도청
            return CLLocationCoordinate2D(latitude: 33.489032, longitude: 126.498224)
        
        }
    }
    
    
    var name: String {
        switch self {
        case .everyDay:
            return "상설장"
        case .fiveDay:
            return "5일장"
        case .seoul:
            return "서울특별시"
        case .gyeonggi_do:
            return "경기도"
        case .gangwon_do:
            return "강원특별자치도"
        case .chungcheongbuk_do:
            return "충청북도"
        case .chungcheongnam_do:
            return "충청남도"
        case .gyeongsangbuk_do:
            return "경상북도"
        case .gyeongsangnam_do:
            return "경상남도"
        case .jeollabuk_do:
            return "전라남도"
        case .jeollanam_do:
            return "전라북도"
        case .jeju_do:
            return "제주특별시"
        
        }
    }
}

