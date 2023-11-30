# 저잣거리
#### 전국 전통시장을 돌아다니며 한국의 정과 지역 특색의 전통시장을 경험하고 기록하는 앱 입니다.

<image src="https://github.com/strongyeom/UiKit_Example/assets/101084872/f1f29624-0a19-4af8-acef-65edc73dae07" width="100%" height="450"/>

# Link

[저잣거리 앱스토어 링크](https://apps.apple.com/kr/app/%EC%A0%80%EC%9E%A3%EA%B1%B0%EB%A6%AC/id6470018379)

[블로그: 개발 과정에 따른 자세한 회고](https://yeomir.tistory.com/62)

# 개발 기간 및 인원
- 2023.09.25 ~ 2023.10.31
- 배포 이후 지속적 업데이트 중 (현재 version 1.1.0)
- 최소 버전: iOS 16.0
- 1인 개발

# 사용 기술
- **MapKit, CoreLocation, Clustering, CustomAnnotation**
- **UIKit, WebKit, SPM, Push Notifications Console**
- **Alamofire, Realm, Kingfisher, SnapKit, SkeletonView, FirebaseAnalyticsWithoutAdid, FirebaseCrashlytics, FirebaseMessaging**
- **MVVM, Router, Singleton, Repository**
- **CompositionalLayout, DiffableDatasource, UISheetPresentation, UISearchViewController, BaseView + Custom ReusableView**
- **NotificationCenter, GCD, FileManager, NSCache, Codable, Hashable**
- **API: 한국관광공사 API, Naver Image API, 전통시장 API**

------
 ``
# 기능 구현 
- `CoreLocation`을 이용하여 현재 사용자의 위치를 활용해서 인근 전통시장을 나타내고, `Custom Annotations` 을 클릭시 전통시장에 대해 기록
   - `UISheetPresentation`의 cutsom Detent를 사용하여 `MapView`와 전통시장에 대한 간략한 정보를 한눈에 확인
- `MapView` 에 오버레이로 `CollectionViewCell` 을 활용하여 지역을 나타내고 Cell 클릭시 `setRegion` 을 사용하여 해당 지역의 전통시장 보여줌
- 네트워크 통신의 과호출을 방지하기 위해 Realm에 전통시장 API 데이터를 저장
  - Realm의 `writeAsync` 사용하여 비동기로 저장하여 저장 속도를 향상
- `DiffableDataSource`를 활용한 data 기반 CollectionView 핸들링
  - DispatchGroup을 사용하여 네트워크 및 Realm의 데이터를 받아온 후 snapshot update 시나리오 구성
- Alamofire의 `URLRequestConvertible`을 사용하여 유지 비용 감소 및 재사용성을 증가.
- `FCM` 및 `Push Notifications Console` 활용 remote Push 기능 구현
- `Realm` DB Table 스키마 구성
  - `EmbeddedObject` 활용한 Subset Pattern
- Realm의 `fiter` 를 사용하여 Map의 x,y축의 최대, 최소 값을 구하고 해당 영역에 속하는 모든 Annotations 필터링
  - MKMapViewDelegate 의 `regionDidChangeAnimated` 메서드를 통해 span 값을 활용하여 x축, y축 최대 최솟값 연산
  - Realm의 filter에서 `BETWEEN AND` 를 활용하여 DB에서 x축, y축 최대 최소에 속하는 값 필터링 



# Trouble Shooting
### A. 네트워크 통신 후 Realm에 저장할때 오래걸리는 속도 개선 - Realm writeAsync 사용
전통시장 API의 모든 데이터는 1600개 가량이었고 한번의 콜수로 최대로 받아올 수 있는 데이터는 100개였기 때문에 for문을 활용하여 배열에 담고
모든 데이터가 배열에 담기면 Realm에 저장하려고 했지만 데이터를 비동기로 받아오기 때문에 모든 데이터를 받아오는데 까지 8 ~ 10초가 걸림 
해결을 위해 DispatchGroup을 사용하여 for문 시작할때 enter() 배열에 담기면 leave()를 사용하여 for문이 끝나면 notify로 한번에 Realm에 저장 
```swift
    var pageCount = Array(1...16)
    
    let realmManager = RealmManager()

    var marketList: TraditionalMarket = TraditionalMarket(response: Response.init(body: Body.init(items: [], totalCount: "", numOfRows: "", pageNo: "")))
    
    let group = DispatchGroup()
    
    /// 전통시장 API
    func request() {
        for page in pageCount {
            group.enter()
            NetworkManager.shared.request(api: .marketInfomation(page: "\(page)")) { [weak self] response in
                
                guard let self else { return }
                self.marketList.response.body.items.append(contentsOf:response)
                print("marketList.response.body.items : \(marketList.response.body.items.count)")
                self.group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self else { return }
            
            self.realmManager.addDatas(markets: self.marketList.response.body.items)
            print("마켓 이름들 : \(self.marketList.response.body.items.count)")
        }
    }
```

그래도 해결이 되지 않아 원인을 찾아보니 Realm에서 연산을 할때 MainThread에서 동작하기 때문에 비동기적으로 저장하는 코드가 필요
처음에는 Realm에 데이터를 저장할때 비동기적으로 실행하기 위해 DispatchQueue.global()을 사용
```swift
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
```

Realm 공식문서를 확인해보니 지원해주는 메서드가 있어 리팩토링 했습니다. writeAsync 입니다.

```swift
    func addDatas(markets: [Item]) {
        let latitudeZeroFilterdMarket = markets.filter { $0.latitude != ""}

        realm.writeAsync {
            let traditionalMarkets = latitudeZeroFilterdMarket.map {
                TraditionalMarketRealm(marketName: $0.marketName, marketType: $0.marketType, loadNameAddress: $0.loadNameAddress, address: $0.address, marketOpenCycle: $0.marketOpenCycle, publicToilet: $0.publicToilet, latitude: $0.latitude, longitude: $0.longitude, popularProducts: $0.popularProducts, phoneNumber: $0.phoneNumber)
                
            }
            
            let allOfTraditionalMarket = traditionalMarkets + self.userDirectAddMarket()
            
            self.realm.add(allOfTraditionalMarket)
        }
    }
```

## 현재 디바이스 화면에 보여지는 부분의 영역만 필터링하여 메모리 최적화
## DiffableDataSource를 사용할때 섹션에 따른 데이터 모듈화
