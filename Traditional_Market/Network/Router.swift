//
//  Router.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/25.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    
    // 공공데이터 포털 디코딩 키
    private static let marketKey = "UQybVf/BVAsYaLeP9xLFftf6XvnhuY3nWPU72kKjfSPporofcAGn6UQp+G9ftv2cI9VQxA9Fq0B/tIWxZ2lavg=="
    private static let naverKey = "myXCWsXxrg83Q4L0SAdP"
    private static let naverSecretKey = "2s8Jgd07Ij"
    
    case marketInfomation(page: String)
    case naverImgae(search: String)
    
    // endPoint에서 URL로 바뀌기 때문에 String으로 설정
    // URL 타입으로 설정
    private var baseURL: URL {
        
        switch self {
        case .marketInfomation:
            return URL(string: "http://api.data.go.kr/openapi/tn_pubr_public_trdit_mrkt_api")!
        case .naverImgae:
            return URL(string: "https://openapi.naver.com/v1/search/image.json")!
        }
        
    }
    
    private var header: HTTPHeaders {
        
        switch self {
        case .marketInfomation:
            return [:]
        case .naverImgae:
            return [
                "X-Naver-Client-Id" : Router.naverKey,
                "X-Naver-Client-Secret" : Router.naverSecretKey
            ]
        }
    }
    
    private var method: HTTPMethod {
        return .get
    }
    
    var query: [String: String] {
        switch self {
        case .marketInfomation(page: let page):
            return [
                "serviceKey": Router.marketKey,
                "pageNo": page,
                "numOfRows": "100",
                "type": "json"
            ]
            
        case .naverImgae(let search):
            return [
                "query": search,
                "display": "30",
                "start": "1",
                "sort": "sim"
            ]
        }
    }
    // asURLRequest() 만 외부에서 사용할 것이기 때문에 그 외의 프로퍼티는 private으로 설정해준다.
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: baseURL)
        // 헤더 및 메서드 추가
        request.headers = header
        request.method = method
        
        // encoding ~ 했던것 처럼 추가 코드 필요, 오픈 API 사용시 destination: .methodDependent 많이 씀
        request = try URLEncodedFormParameterEncoder(destination: .methodDependent).encode(query, into: request)
        
        // 내부에서 만들어 놓은 url : endPoint 사용
        // var request = URLRequest(url: url)
        
        return request
    }
}
