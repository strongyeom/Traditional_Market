//
//  TraditionalMarket.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/27.
//

import Foundation

// MARK: - TraditionalMarket
struct TraditionalMarket: Decodable, Hashable {
    var response: Response
}

// MARK: - Response
struct Response: Decodable, Hashable {
    var body: Body
}

// MARK: - Body
struct Body: Decodable, Hashable {
    var items: [Item]
    let totalCount, numOfRows, pageNo: String
}

// MARK: - Item
struct Item: Decodable, Hashable {
    let marketName: String // 시장 이름
    let marketType: String // 상설장 or 5일장
    let loadNameAddress, address: String // 지번, 도로명
    let marketOpenCycle: String // 매일 or 1일, 3일, 5일
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
