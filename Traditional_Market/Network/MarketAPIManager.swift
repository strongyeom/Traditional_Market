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
    
    let group = DispatchGroup()
    
    func request() {
        for page in pageCount {
            group.enter()
            NetworkManager.shared.request(api: .marketInfomation(page: "\(page)")) { [weak self] response in
                
                guard let self else { return }
                marketList.response.body.items.append(contentsOf:response)
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self else { return }
            
            self.realmManager.addDatas(markets: self.marketList.response.body.items)
            print("마켓 이름들 : \(self.marketList.response.body.items.count)")
        }
        
    }
    
    func requestNaverImage(search: String, completionHandler: @escaping((NaverMarketImage) -> Void)) {
        
        NetworkManager.shared.reqeustImage(api: Router.naverImgae(search: search)) { response in
            guard let response else { return }
            completionHandler(response)
        }
    }
    // 서울 "126.9787960237", "37.5655015943"
    func requstKoreaFestivalLocationBase(lati: Double, long: Double, completionHandler: @escaping(([FestivalItem]) -> Void)) {
        NetworkManager.shared.requestLocationBase(api: Router.festivalInfo(longtitude: long, latitiue: lati)) { response in
            completionHandler(response)
        }
    }
}
