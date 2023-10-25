//
//  Router.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/25.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    
    private static let key = "myXCWsXxrg83Q4L0SAdP"
    private static let secretKey = "2s8Jgd07Ij"
  
    case naverImgae(search: String)
    
    // endPoint에서 URL로 바뀌기 때문에 String으로 설정
    // URL 타입으로 설정
    private var baseURL: URL {
        return URL(string: "https://openapi.naver.com/v1/search/image.json")!
    }
 
    private var header: HTTPHeaders {
        return [
            "X-Naver-Client-Id" : Router.key,
            "X-Naver-Client-Secret" : Router.secretKey
        ]
    }

    private var method: HTTPMethod {
        return .get
    }
    
    var query: [String: String] {
        switch self {
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

