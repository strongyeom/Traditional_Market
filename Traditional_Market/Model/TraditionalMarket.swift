//
//  TraditionalMarket.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/27.
//

import Foundation

// MARK: - TraditionalMarket
struct TraditionalMarket: Decodable, Hashable {
    let response: Response
}

// MARK: - Response
struct Response: Decodable, Hashable {
    let body: Body
}

// MARK: - Body
struct Body: Decodable, Hashable {
    let items: [Item]
    let totalCount, numOfRows, pageNo: String
}

// MARK: - Item
struct Item: Decodable, Hashable {
    let marketName: String // 시장 이름
    let marketType: MrktType // 상설장 or 5일장
    let loadNameAddress, address: String // 지번, 도로명
    let marketOpenCycle: MrktEstblCycle // 매일 or 1일, 3일, 5일
    let publicToilet: String
    let latitude, longitude: String
    let popularProducts: String
    let phoneNumber: String

    enum CodingKeys: String, CodingKey {
        case marketName = "mrktNm"
        case marketType = "mrktType"
        case loadNameAddress = "rdnmadr"
        case address = "lnmadr"
        case marketOpenCycle = "mrktEstblCycle"
        case latitude
        case longitude
        case popularProducts = "trtmntPrdlst"
        case publicToilet = "pblicToiletYn"
        case phoneNumber
    }
}

enum MrktEstblCycle: String, Decodable, Hashable {
    case twoAndSevenDay = "2일+7일"
    case threeAndEightDay = "3일+8일"
    case fourAndNineDay = "4일+9일"
    case fiveAndTenDay = "5일+10일"
    case everyDay = "매일"
    case everyAndSixDay = "매일+6일"
}

enum MrktType: String, Decodable, Hashable {
    case fiveDay_Market = "5일장"
    case everyDay_Market = "상설장"
    case everyDayAndFiveDay_Market = "상설장+5일장"
}
