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
    
    var rangeFiltetedMarket: Results<TraditionalMarketRealm>!
    
    /// Realm에 데이터 추가하기
    /// - Parameter markets: 네트워크 통신으로 받아온 데이터 배열로 모은 다음에 한번에 Realm에 뿌려주기
    func addDatas(markets: [Item]) {
        let latitudeZeroFilterdMarket = markets.filter { $0.latitude != ""}
        DispatchQueue.global().async {
            let realm = try! Realm()
            let traditionalMarkets = latitudeZeroFilterdMarket.map {
                TraditionalMarketRealm(marketName: $0.marketName, marketType: $0.marketType, loadNameAddress: $0.loadNameAddress, address: $0.address, marketOpenCycle: $0.marketOpenCycle, publicToilet: $0.publicToilet, latitude: $0.latitude, longitude: $0.longitude, popularProducts: $0.popularProducts, phoneNumber: $0.phoneNumber)
                
            }
            
            let allOfTraditionalMarket = traditionalMarkets + self.userDirectAddMarket()
            try! realm.write {
                realm.add(allOfTraditionalMarket)
            }
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
    
    func selectedRemoveData(market: FavoriteTable) {
        
        do {
            try realm.write {
                realm.delete(market)
            }
        } catch {
            
        }
    }
    
    /// Realm Favorite - DB 수정하기
    func updateItem(id: ObjectId, memoText: String) {
        
        do {
            // 트랜잭션에게 값 전달
            try realm.write {
                // Realm Update 해당 record중에 요소만 업데이트
                realm.create(FavoriteTable.self, value: ["_id":id, "memo": memoText] as [String : Any], update: .modified)
            }
        } catch {
            print(error)
        }
    }
    
    
    // MARK: - 필터링 관련
    
    
    func myMarketCollectionList() -> Results<TraditionalMarketRealm> {
        let aa: Results<TraditionalMarketRealm>
        aa = fetch().where({
            $0.myFavorite.count != 0
        })
        return aa
    }
    
    /// Realm에서 해당 지역 필터하기
    /// - Parameter region: 해당 지역
    /// - Returns: 필터된 지역
    func filterData(region: String, rangeMarket: Results<TraditionalMarketRealm>, day: String?) -> Results<TraditionalMarketRealm> {
        if region == "상설장" || region == "5일장" {
            print("RealmManager rangeFiltetedMarket \(rangeMarket.count)")
            let result = rangeMarket.where {
                $0.marketType.contains(region)
            }
            
            if let day = day {
                let bb = result.where {
                    $0.marketOpenCycle.contains(day)
                }
               
                print("aaaaa-----aaaa : 갯수 \(bb.count)")
                return bb
            }
           
            return result
        } else {
    
            let result = rangeMarket.where {
                $0.address.contains(region)
            }
            return result
        }
    }
    
    /// Search결과 필터링
    func searchFilterData(text: String) -> Results<TraditionalMarketRealm> {
        let searchResult = fetch().where {
            $0.marketName.contains(text.localized)
        }
        return searchResult
    }
    
    
    /// 모든 어노테이션을 SearchText로 검색한 것만 필터링
    func allOfAnnotationSearchFilter(text: String) -> Results<TraditionalMarketRealm> {
        let result = fetch().where {
            $0.marketName.contains(text)
        }
        print("필터된 갯수 : \(result.count)")
        print("해당 시자 이름 : \(result.map { $0.marketName })")
        
        return result
    }
    
    
    /// 반경안에 있는 어노테이션만 보여주기
    func mapViewRangeFilterAnnotations(minLati: Double, maxLati: Double, minLong: Double, maxLong: Double) -> Results<TraditionalMarketRealm> {
        // Realm에 있는 좌표중에 매개변수로 들어오는 Double 값 범위 안에 있다면 FilterRealm에 담아라
        let convertToStringMinLati = String(minLati)
        let convertToStringMaxLati = String(maxLati)
        let convertToStringMinLong = String(minLong)
        let convertToStringMaxLong = String(maxLong)
        
        
        
        rangeFiltetedMarket = realm.objects(TraditionalMarketRealm.self).filter("latitude BETWEEN {\(convertToStringMinLati), \(convertToStringMaxLati)} AND longitude BETWEEN {\(convertToStringMinLong), \(convertToStringMaxLong)}")
        return rangeFiltetedMarket
    }
    
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
                print("선택했을때 추가되는 favoriteMarket : \(favoriteMarket._id)")
                filterEqualID.myFavorite.append(favoriteMarket)
            }
        } catch {
            print("myFavoriteMarket - \(error.localizedDescription)")
        }
    }
    
    
    /// myFavoriteRealm 데이터 불러오기
    func allOfFavoriteRealmCount() -> Results<FavoriteTable> {
        let favoriteTable = realm.objects(FavoriteTable.self).sorted(byKeyPath: "date", ascending: false)
        return favoriteTable
    }
    
    func calculateStampCountToLevelLabel() -> String {
        let totalCount: Double = Double(allOfFavoriteRealmCount().count) / 3
        
        switch totalCount {
        case 0..<2:
            return "LV.1"
        case 2..<3:
            return "LV.2"
        case 3..<4:
            return "LV.3"
        case 4..<5:
            return "LV.4"
        case 5..<6:
            return "LV.5"
        case 6..<7:
            return "LV.6"
        case 7..<8:
            return "LV.7"
        case 8..<9:
            return "LV.8"
        case 9..<10:
            return "LV.9"
        default:
            return "LV.Max"
        }
    }
    
}

