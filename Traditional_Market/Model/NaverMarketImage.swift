//
//  NaverMarketImage.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/01.
//
import Foundation

// MARK: - NaverMarketImage
struct NaverMarketImage: Decodable {
//    let lastBuildDate: String
//    let total, start, display: Int
    var items: [NaverItem]
}

// MARK: - Item
struct NaverItem: Decodable {
   // let title: String
    let link: String
    let thumbnail: String
   // let sizeheight, sizewidth: String
}
