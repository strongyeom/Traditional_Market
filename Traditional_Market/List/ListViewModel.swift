////
////  ConferenceVideoController.swift
////  Traditional_Market
////
////  Created by 염성필 on 2023/11/01.
////
//

import UIKit
import RealmSwift

struct ExampleModel: Hashable {
    let uuid: String = UUID().uuidString
    var marketName: String
    var marketType: String // 상설장 or 5일장
    var loadNameAddress: String? // 지번
    var address: String?
    var marketOpenCycle: String? // 매일 or 1일, @Persisted 5일
    var publicToilet: String?
    var latitude: Double
    var longitude: Double
    var popularProducts: String?
    var phoneNumber: String?
}

struct ExampleCollection: Hashable {
    let title: String
    let markets: [ExampleModel]
    
}
