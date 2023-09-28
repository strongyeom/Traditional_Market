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
    
    
    func request(page: Int, completionHandler: @escaping(([Item]) -> Void)) {
        
        let url = URL(string: "http://api.data.go.kr/openapi/tn_pubr_public_trdit_mrkt_api?serviceKey=UQybVf%2FBVAsYaLeP9xLFftf6XvnhuY3nWPU72kKjfSPporofcAGn6UQp%2BG9ftv2cI9VQxA9Fq0B%2FtIWxZ2lavg%3D%3D&pageNo=\(page)&numOfRows=100&type=json")!
        
        if !realm.isEmpty {
           print("Realm에 데이터가 있으니 데이터 통신 하지 마세요")
        } else {
            AF.request(url)
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
  
    
    
    
    func requestExample(api:IntegrationAPI, completionHandler: @escaping((TraditionalMarket) -> Void)) {
        
//        let url = URL(string: "http://api.data.go.kr/openapi/tn_pubr_public_trdit_mrkt_api?serviceKey=UQybVf%2FBVAsYaLeP9xLFftf6XvnhuY3nWPU72kKjfSPporofcAGn6UQp%2BG9ftv2cI9VQxA9Fq0B%2FtIWxZ2lavg%3D%3D&pageNo=\(page)&numOfRows=100&type=json")!
        AF.request(api.baseURL, method: api.method, parameters: api.query, encoding: URLEncoding(destination: .queryString))
            .responseDecodable(of: TraditionalMarket.self) { response in
                switch response.result {
                case .success(let data):
                    completionHandler(data)
                case .failure(let error):
                    dump(error.localizedDescription)
                }
            }
    }
    
    
    
    
    func requstConvertible(api: Router, completionHandler: @escaping((TraditionalMarket) -> Void)) {
        AF.request(api)
            .responseDecodable(of: TraditionalMarket.self) { response in
                switch response.result {
                case .success(let data):
                    completionHandler(data)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
}
