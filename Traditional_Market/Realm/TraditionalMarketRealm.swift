//
//  TraditionalMarketRealm.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/28.
//

import Foundation
import RealmSwift

class TraditionalMarketRealm: Object {

    
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var marketName: String
    @Persisted var marketType: String // 상설장 or 5일장
    @Persisted var loadNameAddress: String? // 지번
    @Persisted var address: String?
    @Persisted var marketOpenCycle: String? // 매일 or 1일, @Persisted 5일
    @Persisted var publicToilet: String?
    @Persisted var latitude: String?
    @Persisted var longitude: String?
    @Persisted var popularProducts: String?
    @Persisted var phoneNumber: String?
    
    @Persisted var myFavorite: List<FavoriteTable>
    
    convenience init(marketName: String, marketType: String, loadNameAddress: String?, address: String?, marketOpenCycle: String, publicToilet: String?, latitude: String?, longitude: String?, popularProducts: String?, phoneNumber: String?) {
        self.init()
        self.marketName = marketName
        self.marketType = marketType
        self.loadNameAddress = loadNameAddress
        self.address = address
        self.marketOpenCycle = marketOpenCycle
        self.publicToilet = publicToilet
        self.latitude = latitude
        self.longitude = longitude
        self.popularProducts = popularProducts
        self.phoneNumber = phoneNumber
    }
}

