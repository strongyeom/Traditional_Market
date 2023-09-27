////
////  Router.swift
////  Traditional_Market
////
////  Created by 염성필 on 2023/09/27.
////

import Foundation
import Alamofire

enum Router: URLRequestConvertible {




    private static let key = "UQybVf%2FBVAsYaLeP9xLFftf6XvnhuY3nWPU72kKjfSPporofcAGn6UQp%2BG9ftv2cI9VQxA9Fq0B%2FtIWxZ2lavg%3D%3D"

    case allMarket(pageNo: String, numberOfRow: String, type: String)

    // endPoint에서 URL로 바뀌기 때문에 String으로 설정
    // URL 타입으로 설정
    private var baseURL: URL {
        return URL(string: "http://api.data.go.kr/openapi/tn_pubr_public_trdit_mrkt_api")!
    }

    private var method: HTTPMethod {
        return .get
    }

    var query: [String: String] {

        switch self {
        case .allMarket(let pageNo, let numberOfRow, let type):
            return [
                "serviceKey" : Router.key,
                "pageNo": pageNo,
                "numberOfRows": numberOfRow,
                "type": type
            ]
        }
    }



    func asURLRequest() throws -> URLRequest {

        let url = baseURL
        var request = URLRequest(url: url)
        request.method = method

        request = try URLEncodedFormParameterEncoder(destination: .methodDependent).encode(query, into: request)
        print("주소가 어떻게 생겼을까? \(request)")
        return request
    }
}
