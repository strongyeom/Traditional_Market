//
//  ContentIdBaseFestival.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/11/03.
//

struct ContentIDBaseFestival: Decodable {
    let response: ContentIDBaseResponse
}

// MARK: - Response
struct ContentIDBaseResponse: Decodable {
    let body: ContentIDBaseBody
}

// MARK: - Body
struct ContentIDBaseBody: Decodable {
    let items: ContentIDBaseItems
}

// MARK: - Items
struct ContentIDBaseItems: Decodable {
    let item: [ContentIDBaseItem]
}

// MARK: - Item
struct ContentIDBaseItem: Decodable {
    let contentid, contenttypeid, title : String?
    let tel, telname, homepage: String?
    let addr1: String?
    let mapx, mapy: String?
    let overview: String?
}
