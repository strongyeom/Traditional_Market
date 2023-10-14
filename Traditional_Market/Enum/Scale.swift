//
//  Scale.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/07.
//

import CoreLocation

enum Scale {
    // 최대로 줌 아웃 가능 축척
    static let maxDistance: CLLocationDistance = 400000
    // 내 위치 중심 반경 보여주는 축척
    static let myLocationScale: CLLocationDistance = 200
    // 내 위치 범위
    static let myRangeScale: CLLocationDistance = 300
    // 시장 진입 범위
    static let marktRange: CLLocationDistance = 100
}
