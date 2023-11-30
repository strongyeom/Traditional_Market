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
- `CoreLocation`을 이용하여 현재 사용자의 위치를 활용해서 인근 전통시장을 나타내고, `Custom Annotations` 을 클릭시 전통시장에 대해 기록할 수 있습니다.
   - `UISheetPresentation`의 cutsom Detent를 사용하여 `MapView`와 전통시장에 대한 간략한 정보를 한눈에 확인 할 수 있습니다.
- `MapView` 에 오버레이로 `CollectionViewCell` 을 활용하여 지역을 나타내고 Cell 클릭시 `setRegion` 을 사용하여 해당 지역의 전통시장 보여줍니다.
- 네트워크 통신의 과호출을 방지하기 위해 Realm에 전통시장 API 데이터를 저장합니다.
  - Realm의 `writeAsync` 사용하여 비동기로 저장하여 저장 속도를 향상 시켰습니다.
- `DiffableDataSource`를 활용한 data 기반 CollectionView 핸들링했습니다.
    -  DispatchGroup을 사용하여 네트워크 및 Realm의 데이터를 받아온 후 snapshot update 시나리오 구성했습니다.
- Alamofire의 `URLRequestConvertible`을 사용하여 유지 비용 감소 및 재사용성을 증가시켰습니다.
- `FCM` 및 `Push Notifications Console` 활용 remote Push 기능 구현했습니다.
- `Realm` DB Table 스키마 구성
    - `EmbeddedObject` 활용한 Subset Pattern 
    - 전통시장에 대해 기록들을 관리하고 저장할 수 있습니다.



# Trouble Shooting
## 네트워크 통신 후 Realm에 저장할때 오래걸리는 속도 개선 
## 현재 디바이스 화면에 보여지는 부분의 영역만 필터링하여 메모리 최적화
## DiffableDataSource를 사용할때 섹션에 따른 데이터 모듈화
