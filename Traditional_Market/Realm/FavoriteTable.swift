//
//  FavoriteTable.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/03.
//

import Foundation
import RealmSwift

class FavoriteTable: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var marketName: String
    @Persisted var marketType: String // 상설장 or 5일장
    @Persisted var loadNameAddress: String? // 지번
    @Persisted var address: String?
    @Persisted var marketOpenCycle: String? // 매일 or 1일, @Persisted 5일
    @Persisted var latitude: Double
    @Persisted var longitude: Double
    @Persisted var popularProducts: String?
    @Persisted var phoneNumber: String?
    @Persisted var memo: String?
    @Persisted var date: Date
    
    @Persisted(originProperty: "myFavorite") var mainTable: LinkingObjects<TraditionalMarketRealm>
    
    
    convenience init(marketName: String, marketType: String, loadNameAddress: String?, address: String?, marketOpenCycle: String?, latitude: Double, longitude: Double, popularProducts: String, phoneNumber: String?, memo: String?, date: Date) {
        self.init()
        self.marketName = marketName
        self.marketType = marketType
        self.loadNameAddress = loadNameAddress
        self.address = address
        self.marketOpenCycle = marketOpenCycle
        self.latitude = latitude
        self.longitude = longitude
        self.popularProducts = popularProducts
        self.phoneNumber = phoneNumber
        self.memo = memo
        self.date = date
    }
}
