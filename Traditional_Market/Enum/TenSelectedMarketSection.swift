//
//  TenSelectedMarketSection.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/11/02.
//

import Foundation

enum TenSelectedMarketSection: String {
    
    case seoul = "서울풍물시장"
    case daego = "서문시장"
    case incheon = "신포시장"
    case gwangju = "양동시장"
    case suwon = "남문로데오시장"
    case sokcho = "속초관광수산시장"
    case danyang = "단양구경시장"
    case suncheon = "웃장"
    case andong = "안동구시장"
    case jinjo = "진주중앙시장"
    
    case dongdaemoon = "동대문종합시장"
    case yeasan = "예산시장"
    case mangwon = "망원시장"
    
    var description: String {
        switch self {
        case .seoul:
            return "시장 전체가 주황동(구제의류), 초록동(골동품) 등 7가지 무지개색 콘셉트로 구분되어 있어 색깔 따라 구석구석을 둘러보고, 청춘 1번가 테마존에서 7080 교복을 빌려입고 다방에 앉아 레트로 감성을 즐긴 다음, 인근의 청계천과 동대문, DDP, 동묘 등 서울 대표 관광지까지 즐길 수 있음"
        case .daego:
            return "납작만두, 컵막창, 계란김밥 등을 먹으며 버스킹, 대규모 미디어파사드, 미디어아트 등 볼거리를 함께 즐길 수 있고, 인근에 이월드 테마파크, 대표 번화가인 동성로, 김광석 거리와 근대문화골목 등 대구 대표 관광명소까지 둘러볼 수 있음"
        case .incheon:
            return "만두, 닭강정, 공갈빵, 타르트 등 유명 먹거리로 입이 즐겁고, 인근에는 19세기 말 개화기의 이야기를 품은 개항장 거리, 차이나타운과 월미도 테마파크 등이 있어 볼거리도 풍부하며 ‘인천 e지’ 앱을 통해 스마트 관광 체험도 가능함"
        case .gwangju:
            return "통맥(통닭·맥주)축제, 건맥(건어물·맥주)축제, 리버마켓 야시장 등 주제별 행사와 요리·공예 일일 수업 등의 추억거리가 가득하며, 언제나 문화예술 공연·전시가 있는 아시아문화전당, ‘MZ핫플’ 동명동 카페거리와 양림동 벽화마을까지 인근 관광지에서는 아기자기하고 밝은 감성을 느낄 수 있음"
        case .suwon:
            return "호두과자, 달고나 등 길거리 음식 판매와 비즈 공예 등 쥬얼리 가판이 설치되는 수원 골목마켓에 들러 물건을 사고 청소년 야외공연장, 로데오 아트홀에서 청년들의 노래·춤·전시 등을 감상하며 인근의 공방거리에서 도자기, 패브릭 공예 등 나만의 작품을 만들어본 뒤, 화성행궁-팔달문, 조선향교 등을 걸으며 조선시대 전통문화와 현대문화를 함께 느껴볼 수 있음"
        case .sokcho:
            return "바다를 끼고 있어 현지에서 잡은 수산물을 구경하고 속초아이 대관람차에서 바다를 한눈에 조망할 수 있으며, 무동력선인 갯배를 타고 피난민들이 살던 아바이마을에서 과거 어른들의 삶의 모습과 발자취를 느껴볼 수 있음"
        case .danyang:
            return "마늘만두, 흑마늘 누룽지 닭강정 등 단양 특산품인 마늘을 활용한 먹거리가 가득하고, 주변에 국내 최대규모의 민물고기 생태관인 다누리아쿠아리움과 2019 한국관광의 별에 선정된 만천하 스카이워크가 있음"
        case .suncheon:
            return "매년 5월에는 남도 음식거리 축제, 9월 8일에는 국밥 축제가 열릴 만큼 맛있는 국밥집이 많이 있고, 인근에 순천만 국가 정원과 순천만 습지가 있어 가족, 친구들과 함께 자연을 즐길 수 있음"
        case .andong:
            return "찜닭 골목, 떡볶이 골목, 갈비 골목 등 음식특화거리와 전통 탈을 이용한 ‘마스크데이페스티벌’ 등 즐길 거리가 준비되어있고, 인근에 하회마을과 병산서원에서 선비문화를 체험해볼 수 있어 식도락 여행이 가능함"
        case .jinjo:
            return "낮에는 꽈배기, 꿀빵, 식혜 등의 간식, 밤에는 진주 맥주 진맥, 닭튀김, 조개술찜 등 다양한 안주를 맛볼 수 있으며, 풍광이 아름다운 진주성과 남강, 유등테마공원과 진양호 등의 관광지가 인근에 위치함"
        case .dongdaemoon:
            return "서울 동대문종합시장은 대한민국의 대표적인 쇼핑 및 먹거리 명소로 유명합니다. 이곳에서는 다양한 음식거리를 즐길 수 있으며, 특히 떡볶이, 만두, 볶음밥 등의 길거리 음식과 중식 레스토랑이 인기가 높습니다. 시장은 복합적인 쇼핑 환경과 다양한 먹거리로 관광객과 로컬 모두에게 인기가 있습니다."
        case .yeasan:
            return "예산시장은 매달 5일과 0일에 장이 서는 군내 최대 규모 상설시장이었지만 세월이 지나면서 소멸 위기에 처한 시장이었지만 백종원 대표의 손을 거쳐 탄생한 예산시장 맛집은 신광정육점, 금오바베큐, 선봉국수, 시장닭볶음, 어서와U, 구구통닭, 또복이네, 대흥상회, 예터칼국수, 시장중국집, 불판빌려주는집, 고려떡집 총 12개가 있습니다."
        case .mangwon:
            return "망원시장은 한강시민공원 망원지구 관할의 쾌적한 환경 여건을 구비하고 있으며 강변도로 및 도심지역으로 연결되는 교통의 관문이다. 또한 안정된 주거지역으로 생활여건 및 수준 양호한 시장 기반을 가진 2002년 월드컵이 개최된 경기장 인접지역의 대표적인 전통시장이다. 근래에는 망원동에 거주하는 신혼부부 및 싱글족을 겨냥한 신메뉴와 변화를 추구하여 젊은 소비자들이 증가하였다."
        }
    }
    
//    var thumbnail: String {
//        switch self {
//        case .seoul:
//            return ""
//        case .daego:
//            return ""
//        }
//    }
}
