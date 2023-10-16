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
    
    func addData(market: Item) {
        let addMarket =
        TraditionalMarketRealm(marketName: market.marketName, marketType: market.marketType, loadNameAddress: market.loadNameAddress, address: market.address, marketOpenCycle: market.marketOpenCycle, publicToilet: market.publicToilet, latitude: market.latitude, longitude: market.longitude, popularProducts: market.popularProducts, phoneNumber: market.phoneNumber)
        do {
            try realm.write {
                realm.add(addMarket)
            }
        } catch {
            
        }
    }
        /// Realm에 데이터 추가하기
        /// - Parameter market: 추가할 데이터
        func realmAddData(market: Item) {
            
            if !market.latitude.isEmpty {
                checkAfterWriteBackgroundThreadUpdate()
                let realmMainThread = try! Realm()
                
                let traditionalMarket = TraditionalMarketRealm(marketName: market.marketName, marketType: market.marketType, loadNameAddress: market.loadNameAddress, address: market.address, marketOpenCycle: market.marketOpenCycle, publicToilet: market.publicToilet, latitude: market.latitude, longitude: market.longitude, popularProducts: market.popularProducts, phoneNumber: market.phoneNumber)
                
                try! realmMainThread.write {
                    realmMainThread.add(traditionalMarket)
                }
            }
        }
        
        /// 비동기로 작업한 Realm 데이터 MainThread에 동기화 시키기
        func checkAfterWriteBackgroundThreadUpdate() {
            DispatchQueue.global().async {
                // autoreleasepool : 자동으로 해제되는게 아니라 해당 테스크가 끝날때 메모리에서 해제될 수 있도록 보장한다. -> 안정성을 높이기 위해 사용
                autoreleasepool {
                    let realOnBackground = try! Realm()
                    while true {
                        let marketList = realOnBackground.objects(TraditionalMarketRealm.self)
                        realOnBackground.refresh()
                        //print("realOnBackground 갯수 : \(marketList.count)")
                        if marketList.count > 0 {
                            break
                        }
                    }
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
        
        
        
        /// Realm에서 해당 지역 필터하기
        /// - Parameter region: 해당 지역
        /// - Returns: 필터된 지역
    func filterData(region: String, rangeMarket: Results<TraditionalMarketRealm>) -> Results<TraditionalMarketRealm> {
            if region == "상설장" || region == "5일장" {
                print("RealmManager rangeFiltetedMarket \(rangeMarket.count)")
                let result = rangeMarket.where {
                    $0.marketType.contains(region)
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
                $0.marketName.contains(text)
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
    }
