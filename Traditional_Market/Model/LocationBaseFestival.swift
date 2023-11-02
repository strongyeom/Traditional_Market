//
//  LocationBaseFestival.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/11/03.
//

import Foundation

struct LocationBaseFestival: Decodable {
    let response: FestivalResponse
}

// MARK: - Response
struct FestivalResponse: Decodable {
    let body: FestivalBody
}

// MARK: - Body
struct FestivalBody: Decodable {
    let items: FestivalItems
    let numOfRows, pageNo, totalCount: Int
}

// MARK: - Items
struct FestivalItems: Decodable {
    let item: [FestivalItem]
}

// MARK: - Item
struct FestivalItem: Decodable {
    let areacode, contentid, contenttypeid, createdtime, dist: String
    let firstimage, firstimage2: String
    let mapx, mapy, modifiedtime: String
    let tel, title: String

    enum CodingKeys: String, CodingKey {
        case areacode, contentid, contenttypeid, createdtime, dist, firstimage, firstimage2
        case mapx, mapy, modifiedtime, tel, title
    }
}
