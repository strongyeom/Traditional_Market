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
    
    var exampleList: TraditionalMarket = TraditionalMarket(response: Response.init(body: Body.init(items: [], totalCount: "", numOfRows: "", pageNo: "")))
    
    func request(completionHandler: @escaping ((TraditionalMarket) -> Void)) {
        
        for page in pageCount {
            NetworkManager.shared.request(page: page) { response in
                
                
                self.exampleList.response.body.items.append(contentsOf: response)
               
                completionHandler(self.exampleList)
            }
        }
       
    }
    
}
