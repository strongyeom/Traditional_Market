//
//  RealmManager.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/28.
//

import Foundation
import RealmSwift
import CoreLocation

class RealmManager {

    private let realm = try! Realm()

    var marketList: Results<TraditionalMarketRealm>!

    /// Realm에 데이터 추가하기
    /// - Parameter market: 추가할 데이터
    func addData(market: Item) {
        let aa =
        TraditionalMarketRealm(marketName: market.marketName, marketType: market.marketType, loadNameAddress: market.loadNameAddress, address: market.address, marketOpenCycle: market.marketOpenCycle, publicToilet: market.publicToilet, latitude: market.latitude, longitude: market.longitude, popularProducts: market.popularProducts, phoneNumber: market.phoneNumber)

        do {
            try realm.write {
                realm.add(aa)
            }
        } catch {
            print(error.localizedDescription)
        }
    }


    /// Realm 불러오기
    /// - Returns: 모든 데이터 불러오기
    func fetch() -> Results<TraditionalMarketRealm> {
        
        do {
            try realm.write {
               marketList = realm.objects(TraditionalMarketRealm.self)
            }
        } catch {
            print(error.localizedDescription)
        }
        return marketList
    }


    /// Realm에서 해당 지역 필터하기
    /// - Parameter region: 해당 지역
    /// - Returns: 필터된 지역
    func filterData(region: String) -> Results<TraditionalMarketRealm> {
        let result = realm.objects(TraditionalMarketRealm.self).where { $0.address.contains(region)
        }
        return result
    }
    
    
    /// Realm에서 내가 선택한 전통시장
    /// - Parameter title: 선택한 전통시장 이름
    /// - Returns: 해당 전통시장 데이터
    func selectedCity(location: CLLocationCoordinate2D) -> Results<TraditionalMarketRealm> {
        let aa = realm.objects(TraditionalMarketRealm.self).where {
            $0.latitude == String(location.latitude) && $0.longitude == String(location.longitude)
            
        }
        return aa
    }
    


}
