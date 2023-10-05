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
        let addMarket =
        TraditionalMarketRealm(marketName: market.marketName, marketType: market.marketType, loadNameAddress: market.loadNameAddress, address: market.address, marketOpenCycle: market.marketOpenCycle, publicToilet: market.publicToilet, latitude: market.latitude, longitude: market.longitude, popularProducts: market.popularProducts, phoneNumber: market.phoneNumber)
        
        do {
            try realm.write {
                realm.add(addMarket)
                   
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
    
    // 반경안에 있는 어노테이션만 보여주기
    func mapViewRangeFilterAnnotations(minLati: Double, maxLati: Double, minLong: Double, maxLong: Double) -> Results<TraditionalMarketRealm> {
        // Realm에 있는 좌표중에 매개변수로 들어오는 Double 값 범위 안에 있다면 FilterRealm에 담아라
        
        let convertToStringMinLati = String(minLati)
        let convertToStringMaxLati = String(maxLati)
        let convertToStringMinLong = String(minLong)
        let convertToStringMaxLong = String(maxLong)
        
        let result = realm.objects(TraditionalMarketRealm.self).filter("latitude BETWEEN {\(convertToStringMinLati), \(convertToStringMaxLati)} AND longitude BETWEEN {\(convertToStringMinLong), \(convertToStringMaxLong)}")
        return result
    }
    /*
     let progressBetween30and60 = tasks.filter("progressMinutes BETWEEN {30, 60}")
     print("Tasks with progress between 30 and 60 minutes: \(progressBetween30and60.count)")
     */
    
    
    /// Realm에서 내가 선택한 전통시장
    /// - Parameter title: 선택한 전통시장 이름
    /// - Returns: 해당 전통시장 데이터
    func selectedCity(location: CLLocationCoordinate2D) -> Results<TraditionalMarketRealm> {
        let filterCity = realm.objects(TraditionalMarketRealm.self).where {
            $0.latitude == location.latitude && $0.longitude == location.longitude
            
        }
        return filterCity
    }
    
    
    
    /// 선택된 전통시장 안에 메모 추가하기
    /// - Parameter market: 선택된 전통시장
    func myFavoriteMarket(market: TraditionalMarketRealm, text: String) {
        
        let filterEqualID = realm.objects(TraditionalMarketRealm.self).where {
            $0._id == market._id
        }.first!
        
        let favoriteMarket = FavoriteTable(marketName: market.marketName, marketType: market.marketType, loadNameAddress: market.loadNameAddress, address: market.address, marketOpenCycle: market.marketOpenCycle, latitude: market.latitude, longitude: market.longitude, popularProducts: market.popularProducts ?? "", phoneNumber: market.phoneNumber, memo: text, date: Date())
        
        do {
            try realm.write {
                filterEqualID.myFavorite.append(favoriteMarket)
            }
        } catch {
            print("myFavoriteMarket - \(error.localizedDescription)")
        }
    }
    
    // myFavoriteRealm 데이터 불러오기
    func allOfFavoriteRealmCount() -> Results<FavoriteTable> {
        let aa = realm.objects(FavoriteTable.self).sorted(byKeyPath: "date", ascending: false)
        return aa
    }
}
