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

    let realmManager = RealmManager()
    
    var aa: [Item] = []
    
    var marketList: TraditionalMarket = TraditionalMarket(response: Response.init(body: Body.init(items: [], totalCount: "", numOfRows: "", pageNo: "")))
    
    
    
    
    func request(completionHandler: @escaping ((TraditionalMarket) -> Void)) {
        
        for page in pageCount {
            NetworkManager.shared.request(page: page) { [weak self] response in
                
                guard let self else { return }
                self.marketList.response.body.items.append(contentsOf: response)
                
                let _ = response.map {
                    self.realmManager.realmAddData(market: $0)
                }
            }
        }
    }
    
    func requestNaverImage(search: String, completionHandler: @escaping((NaverMarketImage) -> Void)) {
        
        NetworkManager.shared.reqeustImage(search: search) { response in
            guard let response else { return }
            completionHandler(response)
        }
    }
}
