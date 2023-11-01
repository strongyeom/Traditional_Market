//
//  ConferenceVideoController.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/11/01.
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

class ConferenceVideoController {
    
    let realm = try! Realm()
    let realmManager = RealmManager()
    
    lazy var firstSection: [ExampleModel] = realmManager.firstSectionMarkets().map { ExampleModel(marketName: $0.marketName, marketType: $0.marketType, loadNameAddress: $0.loadNameAddress, address: $0.address, marketOpenCycle: $0.marketOpenCycle, publicToilet: $0.publicToilet, latitude: $0.latitude, longitude: $0.longitude, popularProducts: $0.popularProducts, phoneNumber: $0.phoneNumber)}
    
    lazy var secondSection: [ExampleModel] =
    realmManager.secondSectionMarkets().map {
        ExampleModel(marketName: $0.marketName, marketType: $0.marketType, loadNameAddress: $0.loadNameAddress, address: $0.address, marketOpenCycle: $0.marketOpenCycle, publicToilet: $0.publicToilet, latitude: $0.latitude, longitude: $0.longitude, popularProducts: $0.popularProducts, phoneNumber: $0.phoneNumber)
    }

    
    lazy var collections: [ExampleCollection] = [
        
        
        ExampleCollection(title: "문체부 선정 K-관광마켓 10선", markets: firstSection),
        
        ExampleCollection(title: "요즘 뜨는 시장들", markets: secondSection),
        
        ExampleCollection(title: "세번째 섹션", markets: [
            
            ExampleModel(marketName: "세번째 섹션 - 1", marketType: "", loadNameAddress: "", address: "", marketOpenCycle: "", publicToilet: "", latitude: 0, longitude: 0, popularProducts: "", phoneNumber: ""),
        
            ExampleModel(marketName: "세번째 섹션 - 2", marketType: "", loadNameAddress: "", address: "", marketOpenCycle: "", publicToilet: "", latitude: 0, longitude: 0, popularProducts: "", phoneNumber: ""),
        
            ExampleModel(marketName: "세번째 섹션 - 3", marketType: "", loadNameAddress: "", address: "", marketOpenCycle: "", publicToilet: "", latitude: 0, longitude: 0, popularProducts: "", phoneNumber: ""),
            ExampleModel(marketName: "세번째 섹션 - 3", marketType: "", loadNameAddress: "", address: "", marketOpenCycle: "", publicToilet: "", latitude: 0, longitude: 0, popularProducts: "", phoneNumber: ""),
            ExampleModel(marketName: "세번째 섹션 - 3", marketType: "", loadNameAddress: "", address: "", marketOpenCycle: "", publicToilet: "", latitude: 0, longitude: 0, popularProducts: "", phoneNumber: "")
        ]),

        
        
        
//        ExampleCollection(title: "첫번째 섹션", videos: [
//            ExampleModel(title: "첫번째 섹션 - 1. 아이템", location: "망고"),
//            ExampleModel(title: "첫번째 섹션 - 2. 아이템", location: "바나나"),
//            ExampleModel(title: "첫번째 섹션 - 3. 아이템", location: "키위")
//        ]),
//
//        ExampleCollection(title: "두번째 섹션", videos: [
//            ExampleModel(title: "두번째 섹션 - 1. 아이템", location: "망고 - 2"),
//            ExampleModel(title: "두번째 섹션 - 2. 아이템", location: "바나나 - 2"),
//            ExampleModel(title: "두번째 섹션 - 3. 아이템", location: "키위 - 2"),
//            ExampleModel(title: "두번째 섹션 - 4. 아이템", location: "망고 - 2"),
//            ExampleModel(title: "두번째 섹션 - 5. 아이템", location: "바나나 - 2"),
//            ExampleModel(title: "두번째 섹션 - 6. 아이템", location: "키위 - 2"),
//        ]),
//
//        ExampleCollection(title: "세번째 섹션", videos: [
//            ExampleModel(title: "세번째 섹션 - 1. 아이템", location: "망고 - 3"),
//            ExampleModel(title: "세번째 섹션 - 2. 아이템", location: "바나나 - 3"),
//            ExampleModel(title: "세번째 섹션 - 3. 아이템", location: "키위 - 3"),
//            ExampleModel(title: "세번째 섹션 - 4. 아이템", location: "키위 - 3")
//        ])
    ]
}
