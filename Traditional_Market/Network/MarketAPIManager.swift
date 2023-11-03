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
    
    /// 전통시장 API
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
    
    /// 네이버 이미지 API
    func requestNaverImage(search: String, completionHandler: @escaping((NaverMarketImage) -> Void)) {
        
        NetworkManager.shared.reqeustImage(api: Router.naverImgae(search: search)) { response in
            guard let response else { return }
            completionHandler(response)
        }
    }
    /// 지역기반 한국관광공사 API
    func requstKoreaFestivalLocationBase(lati: Double, long: Double, completionHandler: @escaping(([FestivalItem]) -> Void)) {
        NetworkManager.shared.requestLocationBase(api: Router.festivalInfo(longtitude: long, latitiue: lati)) { response in
            completionHandler(response)
        }
    }
    
    /// ContentID 기반 한국관광공사 API
    func requestKoreFestivalContentIdBase(contentId: Int, completionHandler: @escaping((ContentIDBaseItem) -> Void)) {
        NetworkManager.shared.requestContentIDBase(api: Router.detailFestivalInfo(contentid: contentId)) { response in
            completionHandler(response)
        }
    }
}
