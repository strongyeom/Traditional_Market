//
//  TraditionalMarketViewModel.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/27.
//

import Foundation

//final class TraditionalMarketViewModel {
//    
//    
//    var items: [Item] = []
//    func request(page: Int, completionHandler: @escaping ([Item]) -> Void) {
//        NetworkManager.shared.reqeust(type: Item.self, api: .allMarket(pageNo: String(page), numberOfRow: "100", type: "json")) { response in
//            switch response {
//            case .success(let success):
//                self.items.append(success)
//                dump(self.items)
//                completionHandler(self.items)
//            case .failure(let failure):
//                print(failure.localizedDescription)
//            }
//        }
//    }
//}
