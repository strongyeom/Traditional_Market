//
//  MarketAPIManager.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/28.
//

import Foundation

class MarketAPIManager {
    static let shared = MarketAPIManager()
    
    private init() { }
    
    var pageCount = Array(1...16)
    
    var marketList: TraditionalMarket = TraditionalMarket(response: Response.init(body: Body.init(items: [], totalCount: "", numOfRows: "", pageNo: "")))
    
   
    
    
    func request(completionHandler: @escaping ((TraditionalMarket) -> Void)) {
        
        for page in pageCount {
            NetworkManager.shared.request(page: page) { response in
                
                
                self.marketList.response.body.items.append(contentsOf: response)
               
                completionHandler(self.marketList)
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
