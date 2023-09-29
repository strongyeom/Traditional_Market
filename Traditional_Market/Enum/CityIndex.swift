//
//  CityIndex.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/29.
//

import Foundation

enum CityIndex: Int {
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
    
    
    var indexToCity: String {
        
        switch self.rawValue {
        case 0:
            return "서울특별시"
        case 1:
            return "경기도"
        case 2:
            return "강원도"
        case 3:
            return "충청북도"
        case 4:
            return "충청남도"
        case 5:
            return "경상북도"
        case 6:
            return "경상남도"
        case 7:
            return "전라북도"
        case 8:
            return "전라남도"
        case 9:
            return "제주특별자치도"
        default:
            return ""
        }
    }
}
