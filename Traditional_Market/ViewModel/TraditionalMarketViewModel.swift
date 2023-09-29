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
    
    func selectedMarketInfomation(location: CLLocationCoordinate2D) {
        
        selectedMarket.value = realmManager.selectedCity(location: location).first!
        print("realm", selectedMarket.value)
    }
}
