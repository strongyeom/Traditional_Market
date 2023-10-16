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
    
    var marketList: TraditionalMarket = TraditionalMarket(response: Response.init(body: Body.init(items: [], totalCount: "", numOfRows: "", pageNo: "")))
    
   
    
    
    func request(completionHandler: @escaping ((TraditionalMarket) -> Void)) {
        
        for page in pageCount {
            group.enter()
            NetworkManager.shared.request(page: page) { [weak self] response in
                
                guard let self else { return }
                self.marketList.response.body.items.append(contentsOf: response)
               
                // Batch 작업을 통해 속도 5배 개선
                if page % 4 == 0 {
                    let _ = response.map {
                        self.realmManager.realmAddData(market: $0)
                        self.marketList.response.body.items.removeAll()
                    }
                }
              
            }
            group.leave()
            
        }
        group.notify(queue: .main) {
            completionHandler(self.marketList)
           
            print("Realm파일 경로", self.realm.configuration.fileURL!)
        }
    }
    
    func requestNaverImage(search: String, completionHandler: @escaping((NaverMarketImage) -> Void)) {
        
        NetworkManager.shared.reqeustImage(search: search) { response in
            guard let response else { return }
            completionHandler(response)
        }
    }
}
