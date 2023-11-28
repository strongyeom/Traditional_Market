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

# 주요 화면 및 기능
## Map 화면
- 현대 디바이스가 보여지는 부분에 해당되는 Custom Annotations을 볼 수 있어요
- 상단의 필터링 기능을 사용하여 간편하게 원하는 지역의 전통시장을 볼 수 있어요
- 오일장의 경우 일자 별로 상세 필터링이 가능합니다
- 시장 클릭시 'UISheetPresentation'을 띄어 Map을 보면서 간략히 시장 정보를 확인 및 기록 할 수 있어요

## 리스트 화면 
- 현재 뜨고있는 시장 정보를 한눈에 볼 수 있고, 현재 위치 기반 문화 축제 정보를 확인 할 수 있어요
- 'DiffableDataSource' 를 활용하여 사용자 친화적인 UI로 구성했어요

## 마이페이지 화면
- 시장별로 기록한 메모를 확인 할 수 있어요
- 

# 주요 기능

------

# Trouble Shooting
## 네트워크 통신 후 Realm에 저장할때 오래걸리는 속도 개선 
## 현재 디바이스 화면에 보여지는 부분의 영역만 필터링하여 메모리 최적화
## DiffableDataSource를 사용할때 섹션에 따른 데이터 모듈화
