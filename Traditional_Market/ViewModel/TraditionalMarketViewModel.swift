//
//  TraditionalMarketViewModel.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/27.
//

import Foundation
import CoreLocation

class TraditionalMarketViewModel {
    
    let realmManager = RealmManager()
    
    var selectedMarket: Observable<TraditionalMarketRealm> = Observable(TraditionalMarketRealm(marketName: "", marketType: "", loadNameAddress: "", address: "", marketOpenCycle: "", publicToilet: "", latitude: "", longitude: "", popularProducts: "", phoneNumber: ""))
    
    func selectedMarketInfomation(location: CLLocationCoordinate2D) -> TraditionalMarketRealm {
      //  let aa = realmManager.selectedCity(location: location)
      //  print("어떻게 생긴거야? \(aa)")
        selectedMarket.value = realmManager.selectedCity(location: location).first!
      //  selectedMarket.value = realmManager.selectedCity(location: location)
       // print("TraditionalMarketViewModel -- ", selectedMarket.value)
        return selectedMarket.value
    }
}
