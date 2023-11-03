//
//  FestivalViewModel.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/11/03.
//

import Foundation

class FestivalViewModel {
    
    var festivals = Observable<[ExampleModel]>([])
    
    
    private func request(lati: Double, long: Double) {
        MarketAPIManager.shared.requstKoreaFestivalLocationBase(lati: lati, long: long) { response in
        }
    }
}
