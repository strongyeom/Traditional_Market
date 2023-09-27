//
//  IntegrationAPI.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/27.
//

import Foundation
import Alamofire

enum IntegrationAPI {
    
    private static let key = "UQybVf%2FBVAsYaLeP9xLFftf6XvnhuY3nWPU72kKjfSPporofcAGn6UQp%2BG9ftv2cI9VQxA9Fq0B%2FtIWxZ2lavg%3D%3D"
    
    case traditional(pageNo: String, numberOfRow: String, type: String)
    
    var baseURL: URL {
        switch self {
        case .traditional:
            return URL(string: "http://api.data.go.kr/openapi/tn_pubr_public_trdit_mrkt_api")!
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var query: [String: String] {
        switch self {
        case .traditional(let pageNo, let numberOfRow, let type):
            return [
                "serviceKey" : IntegrationAPI.key,
                "pageNo": pageNo,
                "numberOfRows": numberOfRow,
                "type": type
            ]
        }
    }
    
}
