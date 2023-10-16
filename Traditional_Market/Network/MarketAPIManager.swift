//
//  MarketAPIManager.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/28.
//

import Foundation
import RealmSwift

class MarketAPIManager {
    static let shared = MarketAPIManager()
    
    private init() { }
    
    let realm = try! Realm()
    
    var pageCount = Array(1...16)
    
    let group = DispatchGroup()
    
    let realmManager = RealmManager()
    
    var aa: [Item] = []
    
    var marketList: TraditionalMarket = TraditionalMarket(response: Response.init(body: Body.init(items: [], totalCount: "", numOfRows: "", pageNo: "")))
    
    
    
    
    func request(completionHandler: @escaping ((TraditionalMarket) -> Void)) {
        
        for page in pageCount {
            group.enter()
            print("측정 시작 전: \(Date().formatted(date: .omitted, time: .complete))")
            NetworkManager.shared.request(page: page) { [weak self] response in
                
                guard let self else { return }
                self.marketList.response.body.items.append(contentsOf: response)
                
                // enter와 leave를 통해 모았다가 한번에 realm에 저장
                let _ = response.map {
                    print("측정 시작 후: \(Date().formatted(date: .omitted, time: .complete))")
                    self.realmManager.realmAddData(market: $0)
                }
            }
            
        }
        
        group.notify(queue: .main) {
            completionHandler(self.marketList)
            print("파일 경로 : \(self.realm.configuration.fileURL!)")
        }
    }
    
    func requestNaverImage(search: String, completionHandler: @escaping((NaverMarketImage) -> Void)) {
        
        NetworkManager.shared.reqeustImage(search: search) { response in
            guard let response else { return }
            completionHandler(response)
        }
    }
}
