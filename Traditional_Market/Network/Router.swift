
 //
 //  Router.swift
 //  Traditional_Market
 //
 //  Created by 염성필 on 2023/09/27.
 //

 import Foundation
 import Alamofire

 enum Router: URLRequestConvertible {

     private static let marketKey = "UQybVf%2FBVAsYaLeP9xLFftf6XvnhuY3nWPU72kKjfSPporofcAGn6UQp%2BG9ftv2cI9VQxA9Fq0B%2FtIWxZ2lavg%3D%3D"
     // 인코딩 키 UQybVf%2FBVAsYaLeP9xLFftf6XvnhuY3nWPU72kKjfSPporofcAGn6UQp%2BG9ftv2cI9VQxA9Fq0B%2FtIWxZ2lavg%3D%3D
     
     // 디코딩 키
     //UQybVf/BVAsYaLeP9xLFftf6XvnhuY3nWPU72kKjfSPporofcAGn6UQp+G9ftv2cI9VQxA9Fq0B/tIWxZ2lavg==
     
     case allMarket(pageNo: String, numberOfRow: String, type: String)

     // endPoint에서 URL로 바뀌기 때문에 String으로 설정
     // URL 타입으로 설정
     private var baseURL: URL {
         switch self {
         case .allMarket:
             return URL(string: "http://api.data.go.kr/openapi/tn_pubr_public_trdit_mrkt_api")!
         default:
             return URL(string: "")!
         }
       
     }
     
     private var header: HTTPHeaders {
         switch self {
         case .allMarket:
             return ["": ""]
         default:
             return ["": ""]
         }
         
     }
     
     private var method: HTTPMethod {
         return .get
     }

     var query: [String: String] {
         switch self {
         case .allMarket(let pageNo, let numberOfRow, let type):
             return [
                 "serviceKey": Router.marketKey,
                 "pageNo": pageNo,
                 "numOfRows": numberOfRow,
                 "type": type
             ]
         }
     }


     func asURLRequest() throws -> URLRequest {

         let url = baseURL
         print("marketKey", Router.marketKey)
         var request = URLRequest(url: url)
         request.headers = header
         request.method = method

         request = try URLEncodedFormParameterEncoder(destination: .methodDependent).encode(query, into: request)
         
         print("주소가 어떻게 생겼을까? \(request)")
         return request
     }
 }
