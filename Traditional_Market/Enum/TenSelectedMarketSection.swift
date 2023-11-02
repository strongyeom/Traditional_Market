//
//  TenSelectedMarketSection.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/11/02.
//

import Foundation

enum TenSelectedMarketSection: String {
    
    case seoul = "서울풍물시장"
    case daego = "서문시장"

    var description: String {
        switch self {
        case .seoul:
            return "시장 전체가 주황동(구제의류), 초록동(골동품) 등 7가지 무지개색 콘셉트로 구분되어 있어 색깔 따라 구석구석을 둘러보고, 청춘 1번가 테마존에서 7080 교복을 빌려입고 다방에 앉아 레트로 감성을 즐긴 다음, 인근의 청계천과 동대문, DDP, 동묘 등 서울 대표 관광지까지 즐길 수 있음"
        case .daego:
            return "납작만두, 컵막창, 계란김밥 등을 먹으며 버스킹, 대규모 미디어파사드, 미디어아트 등 볼거리를 함께 즐길 수 있고, 인근에 이월드 테마파크, 대표 번화가인 동성로, 김광석 거리와 근대문화골목 등 대구 대표 관광명소까지 둘러볼 수 있음"
        }
    }
    
    var thumbnail: String {
        switch self {
        case .seoul:
            return ""
        case .daego:
            return ""
        }
    }
}
