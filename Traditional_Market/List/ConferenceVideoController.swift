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
    
    var festivalViewModel = FestivalViewModel()
    
    var collections: [ExampleCollection] = []
    var thirdArray: [ExampleModel] = []
    let group = DispatchGroup()
    
    var savedLatitude: Double? = UserDefaults.standard.double(forKey: "SavedLatitude")
    var savedLongtitude: Double? = UserDefaults.standard.double(forKey: "SavedLongtitude")
    
    init() {
        
        let firstSection: [ExampleModel] = realmManager.firstSectionMarkets().map { ExampleModel(marketName: $0.marketName, marketType: $0.marketType, loadNameAddress: $0.loadNameAddress, address: $0.address, marketOpenCycle: $0.marketOpenCycle, publicToilet: $0.publicToilet, latitude: $0.latitude, longitude: $0.longitude, popularProducts: $0.popularProducts, phoneNumber: $0.phoneNumber)}
        print("최초 좌표: savedLatitude - \(savedLatitude)")
        print("최초 좌표: savedLongtitude - \(savedLongtitude)")
        let secondSection: [ExampleModel] =
        realmManager.secondSectionMarkets().map {
            ExampleModel(marketName: $0.marketName, marketType: $0.marketType, loadNameAddress: $0.loadNameAddress, address: $0.address, marketOpenCycle: $0.marketOpenCycle, publicToilet: $0.publicToilet, latitude: $0.latitude, longitude: $0.longitude, popularProducts: $0.popularProducts, phoneNumber: $0.phoneNumber)}
     
            group.enter()
  // 37.566713, 126.978428
        MarketAPIManager.shared.requstKoreaFestivalLocationBase(lati: 37.566713, long: savedLongtitude ?? 126.978428) { response in
               // dump(response)
                
                let _ = response.map { fes in
                    self.thirdArray.append(ExampleModel(marketName: fes.title, marketType: "", loadNameAddress: fes.contenttypeid, address: fes.contentid, marketOpenCycle: "", publicToilet: "", latitude: Double(fes.mapy)!, longitude: Double(fes.mapx)!, popularProducts: "", phoneNumber: fes.tel.replacingOccurrences(of: "<br>", with: "")))
                }
                self.group.leave()
            }
            
            group.notify(queue: .main) {
                self.collections = [
                    
                    ExampleCollection(title: "문체부 선정 K-관광마켓 10선", markets: firstSection),
                    
                    ExampleCollection(title: "요즘 뜨는 시장들", markets: secondSection),
                    
                    ExampleCollection(title: "내 지역 문화 축제", markets: self.thirdArray)
                ]
            }
        
    }
}
