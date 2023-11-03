//
//  NetworkManager.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/27.
//

import Foundation
import Alamofire
import RealmSwift

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    let realm = try! Realm()
    
    /// 전통시장 API
    func request(api: Router, completionHandler: @escaping(([Item]) -> Void)) {
        
        if !realm.isEmpty {
            print("Realm에 데이터가 있으니 데이터 통신 하지 마세요")
        } else {
            AF.request(api)
                .responseDecodable(of: TraditionalMarket.self) { response in
                    switch response.result {
                    case .success(let data):
                        completionHandler(data.response.body.items)
                    case .failure(let error):
                        dump(error.localizedDescription)
                    }
                }
        }
    }
    
    /// NaverImage API
    func reqeustImage(api: Router, completionHandler: @escaping ((NaverMarketImage?) -> Void)) {
        
        AF.request(api)
            .responseDecodable(of: NaverMarketImage.self) { response in
                switch response.result {
                case .success(let data):
                    completionHandler(data)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
    /// 지역기반 한국관광 공사 API
    func requestLocationBase(api: Router, completionHandler: @escaping (([FestivalItem]) -> Void)) {
        AF.request(api)
            .responseDecodable(of: LocationBaseFestival.self) { response in
                switch response.result {
                case .success(let data):
                    completionHandler(data.response.body.items.item)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
    /// ContentID 기반 한국관광 공사 API
    func requestContentIDBase(api: Router, completionHandler: @escaping((ContentIDBaseItem) -> Void)) {
        AF.request(api)
            .responseDecodable(of: ContentIDBaseFestival.self) { response in
                switch response.result {
                case .success(let data):
                    completionHandler(data.response.body.items.item.first!)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
}
