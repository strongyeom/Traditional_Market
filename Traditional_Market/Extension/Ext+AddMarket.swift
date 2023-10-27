//
//  Ext+AddMarket.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/27.
//

import UIKit

extension RealmManager {

    func userDirectAddMarket() -> [TraditionalMarketRealm] {
        // 시장 데이터에 없는 데이터 수동으로 넣어주기 위한 배열
        let userInputMarketList: [TraditionalMarketRealm] = [
            TraditionalMarketRealm(marketName: "서울풍물시장", marketType: "상설장", loadNameAddress: "서울 동대문구 천호대로4길 21 서울풍물시장", address: "서울 동대문구 신설동 109-5", marketOpenCycle: "매일", publicToilet: "Y", latitude: "37.572740", longitude: "127.025396", popularProducts: "골동품+의류+중고품+지역명소", phoneNumber: "상인회 : 02-2238-2600 / 관리사무소 : 02-2232-3367"),
            TraditionalMarketRealm(marketName: "속초관광수산시장", marketType: "상설장", loadNameAddress: "강원특별자치도 속초시 중앙로147번길 12", address: "강원특별자치도 속초시 중앙동 474-11", marketOpenCycle: "매일", publicToilet: "Y", latitude: "38.204511", longitude: "128.590247", popularProducts: "의류+생활용품+잡화점+수산물+순대+농산물+건어물+닭강정", phoneNumber: "033-635-8433 / 033-633-3501"),
            TraditionalMarketRealm(marketName: "한산5일장", marketType: "5일장", loadNameAddress: "충청남도 서천군 한산면 충절로1173번길 21-1", address: "충청남도 서천군 한산면 지현리 98-9", marketOpenCycle: "1일+6일", publicToilet: "", latitude: "36.084743", longitude: "126.804484", popularProducts: "모시+채소+잡화", phoneNumber: ""),
            TraditionalMarketRealm(marketName: "담양오일장", marketType: "5일장", loadNameAddress: "전남 담양군 담양읍 담주4길 40", address: "전남 담양군 담양읍 담주리 7", marketOpenCycle: "2일+7일", publicToilet: "", latitude: "35.321886", longitude: "126.980975", popularProducts: "치킨+쑥떡+젓갈류+장아찌", phoneNumber: ""),
            TraditionalMarketRealm(marketName: "모란민속5일장", marketType: "5일장", loadNameAddress: "경기 성남시 중원구 둔촌대로 68", address: "경기 성남시 중원구 성남동 4931", marketOpenCycle: "4일+9일", publicToilet: "Y", latitude: "37.428980", longitude: "127.127193", popularProducts: "칼국수+죽류+돼지부속+잡화+원예+생활용품+의류", phoneNumber: "031-721-9905"),
            TraditionalMarketRealm(marketName: "마석민족5일장", marketType: "5일장", loadNameAddress: "경기 남양주시 화도읍 마석중앙로37번길 4", address: "경기 남양주시 화도읍 마석우리 314-2", marketOpenCycle: "3일+8일", publicToilet: "Y", latitude: "37.653177", longitude: "127.304397", popularProducts: "등갈비+닭발+칼국수+잡화+원예+생활용품+의류", phoneNumber: "")
        ]
        
        return userInputMarketList
    }
}
