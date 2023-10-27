//
//  MapView.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/26.
//

import UIKit
import MapKit
import SnapKit
import CoreLocation
import RealmSwift

protocol SettingAlert {
    func showSettingAlert()
}

class MapView : BaseView {
    
    let viewModel = TraditionalMarketViewModel()
    
    let realmManager = RealmManager()

    // 각 City 배열
    let cityList: [City] = [
        City(imageName: "basicStamp", localname: "상설장".localized),
        City(imageName: "checkStamp", localname: "5일장".localized),
        City(imageName: "Seoul", localname: "서울".localized),
        City(imageName: "Gyeonggi-do", localname: "경기도".localized),
        City(imageName: "Gangwon-do", localname: "강원도".localized),
        City(imageName: "Chungcheongbuk-do", localname: "충청북도".localized),
        City(imageName: "Chungcheongnam-do", localname: "충청남도".localized),
        City(imageName: "Gyeongsangbuk-do", localname: "경상북도".localized),
        City(imageName: "Gyeongsangnam-do", localname: "경상남도".localized),
        City(imageName: "Jeollabuk-do", localname: "전라북도".localized),
        City(imageName: "Jeollanam-do", localname: "전라남도".localized),
        City(imageName: "Jeju-do", localname: "제주도".localized)
    ]
    
    var locationManger = {
        var location = CLLocationManager()
      //  location.allowsBackgroundLocationUpdates = true
        location.pausesLocationUpdatesAutomatically = false
        return location
    }()
    
    // 권한 상태
    var authorization: CLAuthorizationStatus = .notDetermined

    private var myRangeAnnotation: [MKAnnotation] = []
    
    // didSelect or DeSelect를 위한 변수
    var mkAnnotationSearchResult: MKAnnotation!
    
    // 상세조건 검색 ✅
    var selectedCell: String?
    
    // VC으로 액션 전달 - 알럿띄우기
    var delegate: SettingAlert?
    
    // 내 위치 버튼 클릭
    var myLocationCompletion: ((Bool) -> Void)?
 
    // 오일장에서 상세조건 버튼 클릭
    var detailFiveMarketCompletion: (() -> Void)?
    
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    
    let locationButtonBgView = {
       let view = UIView()
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        return view
    }()
    
 
    let currentLocationButton = {
       let view = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .light)
        let image = UIImage(systemName: "scope", withConfiguration: imageConfig)
        view.setTitle("", for: .normal)
        view.setImage(image, for: .normal)
        return view
    }()
    
    let detailOpenFiveMarketButtonBgView = {
       let view = UIView()
        view.backgroundColor = .white
        view.isHidden = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let detailOpenFiveMarketBtn = {
       let view = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .light)
        let image = UIImage(systemName: "calendar", withConfiguration: imageConfig)
        view.setImage(image, for: .normal)
        view.tintColor = UIColor(named: "brandColor")
        view.isHidden = true
        return view
    }()
    
    var mapBaseView = {
        let view = MKMapView()
        // 허용안함 눌렀을때 내 위치를 받아 올 수 없어서 보라색 에러 발생함
        // 권한설정에 따라 추가해줬음
        view.cameraZoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: Scale.maxDistance)
        return view
    }()

    // MARK: - configureView
    override func configureView() {
        self.addSubview(mapBaseView)
        mapBaseView.addSubview(locationButtonBgView)
        mapBaseView.addSubview(detailOpenFiveMarketButtonBgView)
        locationButtonBgView.addSubview(currentLocationButton)
        detailOpenFiveMarketButtonBgView.addSubview(detailOpenFiveMarketBtn)
       // mapBaseView.addSubview(currentLocationButton)
        self.currentLocationButton.addTarget(self, action: #selector(currentBtnClicked), for: .touchUpInside)
        self.detailOpenFiveMarketBtn.addTarget(self, action: #selector(detailBtnClicked(_:)), for: .touchUpInside)
        
        configureCity()
        setLocation()
        setMapView()
    }
    
    
    
    // MARK: - Method
    
     func setLocation() {
        locationManger.desiredAccuracy = kCLLocationAccuracyBest // 정확성
        checkDeviceLocationAuthorization()
    }
    
    /// 상태가 바뀔때 마다 권한 확인
     func checkDeviceLocationAuthorization() {
        DispatchQueue.global().async {
            // 위치 서비스를 이용하고 있다면
            if CLLocationManager.locationServicesEnabled() {
                
                if #available(iOS 14.0, *) {
                    self.authorization = self.locationManger.authorizationStatus
                } else {
                    self.authorization = CLLocationManager.authorizationStatus()
                }
                
                DispatchQueue.main.async {
                    print("현재 권한 상태 - \(self.authorization)")
                    self.checkStatuesDeviceLocationAuthorization(status: self.authorization)
                }
            }
        }
    }
    
    /// 권한 설정에 따른 메서드
    /// - Parameter status: 권한 상태
    func checkStatuesDeviceLocationAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("아무것도 결정하지 않았다.")
            // p.list 알람 띄우기
            locationManger.requestWhenInUseAuthorization()
        case .restricted:
            print("권한 설정 거부함")
            // 서울시청
            let seoulCity = CLLocationCoordinate2D(latitude: 37.566713, longitude: 126.978428)
            setRegionScale(center: seoulCity)
            delegate?.showSettingAlert()
        case .denied:
            print("권한 설정 거부함")
            // 서울시청
            let seoulCity = CLLocationCoordinate2D(latitude: 37.566713, longitude: 126.978428)
            setRegionScale(center: seoulCity)
            delegate?.showSettingAlert()
        case .authorizedAlways:
            print("항상 권한 허용")
            locationManger.startUpdatingLocation()
            mapBaseView.userTrackingMode = .follow
            mapBaseView.showsUserLocation = true
        case .authorizedWhenInUse:
            print("한번만 권한 허용")
            locationManger.startUpdatingLocation()
            setRegionScale(center: viewModel.startLocation.value)
            self.currentLocationButton.isSelected = true
            mapBaseView.userTrackingMode = .follow
            mapBaseView.showsUserLocation = true
        case .authorized:
            print("권한 허용 됨")
            locationManger.startUpdatingLocation()
            setRegionScale(center: viewModel.startLocation.value)
            mapBaseView.userTrackingMode = .follow
            mapBaseView.showsUserLocation = true
        @unknown default:
            print("어떤것이 추가 될 수 있음")
        }
    }

//    /// 해당 지역에 들어왔을때 로컬 알림 메서드
    func registLocation() {
        print("내 범위에 속하는 어노테이션 갯수",myRangeAnnotation.count)
        // 내 범위에서 내 위치는 렌더링 하지 않기
        let myLocationRangeRemoveMyLocation = myRangeAnnotation.filter { $0.title!! != "My Location"}

        // 내 위치 반경에 해당하는 어노테이션만 가져오기
        for i in myLocationRangeRemoveMyLocation {
            print("해당 \(i.title!!)에 들어왔습니다.",i.title!!)
            let circleRange = CLCircularRegion(center: i.coordinate, radius: Scale.marktRange, identifier: "\(i.title! ?? "내위치")")

            circleRange.notifyOnEntry = true
            circleRange.notifyOnExit = true
            locationManger.startMonitoring(for: circleRange)
        }
        // 🧐 UNLocationNotificationTrigger 고민해보기
    }
    
    // 내 위치 범위 산정 geofencing
    func setMyRegion(center: CLLocationCoordinate2D) {
        myRangeAnnotation = []
        // MapView에 축척 m단위로 보여주기
        let region = MKCoordinateRegion(center: center, latitudinalMeters: Scale.myLocationScale, longitudinalMeters: Scale.myLocationScale)
        let regionRange = CLCircularRegion(center: center, radius: Scale.myRangeScale, identifier: "내 위치")
        self.mapBaseView.setRegion(region, animated: true)


        print("현재 MapView에서 보여지고 있는 어노테이션 갯수 : \(viewModel.addedAnnotation.value.count)")
        for i in viewModel.addedAnnotation.value {
            if regionRange.contains(i.coordinate) {
                print("\(i.title! ?? "")가 내 위치에 포함되어 있습니다.")
                // 범위안에 있는 것만 따로 배열에 담아서 registLocation타게 하기
                myRangeAnnotation.append(i)
            } else {
                print("\(i.title! ?? "")가 내 위치에 포함되어 있지 않습니다.")
            }
        }
        registLocation()
    }
    
    func setRegionScale(center: CLLocationCoordinate2D) {
        // MapView에 축척 m단위로 보여주기
        let region = MKCoordinateRegion(center: center, latitudinalMeters: Scale.myLocationScale, longitudinalMeters: Scale.myLocationScale)
        
        self.mapBaseView.setRegion(region, animated: true)
    }
    
    func setRegionCityScale(center: CLLocationCoordinate2D) {
        // MapView에 축척 m단위로 보여주기
        let region = MKCoordinateRegion(center: center, latitudinalMeters: Scale.cityRange, longitudinalMeters: Scale.cityRange)
        
        self.mapBaseView.setRegion(region, animated: true)
    }
    
    func setAnnotationSelectedRegionScale(center: CLLocationCoordinate2D) {
        // MapView에 축척 m단위로 보여주기
        let region = MKCoordinateRegion(center: center, latitudinalMeters: Scale.marktRange, longitudinalMeters: Scale.marktRange)
        
        self.mapBaseView.setRegion(region, animated: true)
    }

    /// MapView 위치 반경에 존재하는 어노테이션만 보여주기
    func mapViewRangeInAnnotations(containRange: Results<TraditionalMarketRealm>) {
        let currentAnnotations = self.mapBaseView.annotations
        viewModel.addedAnnotation.value = []
        self.mapBaseView.removeAnnotations(self.mapBaseView.annotations)
        let rangeAnnotation = containRange.map {
            (realItem) -> MKAnnotation in
            let pin = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: realItem.latitude, longitude: realItem.longitude))
            pin.imageName = "checkStamp"
            pin.title = realItem.marketName
            return pin
        }
        
        // 반복문을 사용하여 배열 안에 담아주기
        for i in rangeAnnotation {
            viewModel.mapViewRangeAddedAnnotation(annotation: i)
        }

        // 현재 모든 어노테이션에서 추가한 어노테이션의 좌표가 같지 않은것만 필터링하기
        let removeAnnotations = currentAnnotations.filter { (annotation) in
            !viewModel.addedAnnotation.value.contains(where: {
                $0.coordinate.latitude == annotation.coordinate.latitude && $0.coordinate.longitude == annotation.coordinate.longitude
            })
        }
        // 같지 않은것 어노테이션 빼기
        self.mapBaseView.removeAnnotations(removeAnnotations)
        
        // 기존 어노테이션에 추가하려는 어노테이션이 없으면 추가 배열 생성
        let addAnnotations = viewModel.addedAnnotation.value.filter { newAnnotation in
            !currentAnnotations.contains(where: {
                $0.coordinate.latitude == newAnnotation.coordinate.latitude && $0.coordinate.latitude == newAnnotation.coordinate.longitude
            })
        }
        self.mapBaseView.addAnnotations(addAnnotations)
    }
    
    
    /// 해당 지역 Annotation만 보여주기
    func filterCityAnnotation(filterMarket: Results<TraditionalMarketRealm>, day: String?) {
        let currentAnnotations = self.mapBaseView.annotations
        print("---- currentAnnotations :\(currentAnnotations.count)")
        guard let selectedCell else { return }
        // LazyMapSequence<Results<TraditionalMarketRealm>, MKAnnotation>로 나온것을 배열로 만들어주기 위해 변수 설정
        var mkAnnotationConvert: [MKAnnotation] = []
        self.mapBaseView.removeAnnotations(self.mapBaseView.annotations)
        // mapView에 있는 어노테이션 삭제
        print("filterCityAnnotation - \(selectedCell)")
        let realmAnnotation = realmManager.filterData(region: selectedCell, rangeMarket: filterMarket, day: day).map {
            (realItem) -> MKAnnotation in
            let pin = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: realItem.latitude, longitude: realItem.longitude))
            pin.title = realItem.marketName
            pin.imageName = "checkStamp"
            return pin
        }
        // 반복문을 사용하여 배열 안에 담아주기
        for i in realmAnnotation {
            mkAnnotationConvert.append(i)
        }
        
        let removeAnnotations = currentAnnotations.filter { (annotation) in
            !mkAnnotationConvert.contains(where: {
                $0.coordinate.latitude == annotation.coordinate.latitude && $0.coordinate.longitude == annotation.coordinate.longitude
            })
        }
        self.mapBaseView.removeAnnotations(removeAnnotations)
        
        let addAnnotations = mkAnnotationConvert.filter { newAnnotation in
            !currentAnnotations.contains(where: {
                $0.coordinate.latitude == newAnnotation.coordinate.latitude && $0.coordinate.latitude == newAnnotation.coordinate.longitude
            })
        }
        print("---- mkAnnotationConvert : \(mkAnnotationConvert.count)")
        self.mapBaseView.addAnnotations(addAnnotations)

    }
    
    /// 해당 지역 Annotation만 보여주기
//    func filterCityDetailAnnotation(filterMarket: Results<TraditionalMarketRealm>, day: String) {
//       // let currentAnnotations = self.mapBaseView.annotations
//        guard let selectedCell else { return }
//        // LazyMapSequence<Results<TraditionalMarketRealm>, MKAnnotation>로 나온것을 배열로 만들어주기 위해 변수 설정
//        var mkAnnotationConvert: [MKAnnotation] = []
//        self.mapBaseView.removeAnnotations(self.mapBaseView.annotations)
//        // mapView에 있는 어노테이션 삭제
//        print("filterCityAnnotation - \(selectedCell)")
//        let realmAnnotation = realmManager.fiveMarketDetailDay(day: day)
//            .map {
//            (realItem) -> MKAnnotation in
//            let pin = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: realItem.latitude, longitude: realItem.longitude))
//            pin.title = realItem.marketName
//            pin.imageName = "checkStamp"
//            return pin
//        }
//
//        // 반복문을 사용하여 배열 안에 담아주기
//        for i in realmAnnotation {
//            mkAnnotationConvert.append(i)
//        }
//        self.mapBaseView.addAnnotations(mkAnnotationConvert)
//
//    }
    
    func setMapView() {
        self.mapBaseView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        self.mapBaseView.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        
    }
    
    /// 버튼의 이벤트를 받아 start와 stop 할 수 있음
    func currentLocationBtnIsActive() {
        self.myLocationCompletion = { [weak self] isCurrent in
            print("현재 위치로 버튼 : \(isCurrent)")
            guard let self else { return }
            viewModel.isCurrentLocation.value = isCurrent
            
            switch locationManger.authorizationStatus {
            case .authorizedAlways:
                if viewModel.isCurrentLocation.value {
                    self.locationManger.startUpdatingLocation()
                } else {
                    self.locationManger.stopUpdatingLocation()
                    self.currentLocationButton.tintColor = .black
                }
            case .notDetermined:
                print("notDetermined")
            case .authorizedWhenInUse:
                if viewModel.isCurrentLocation.value {
                    self.locationManger.startUpdatingLocation()
                } else {
                    self.locationManger.stopUpdatingLocation()
                    self.currentLocationButton.tintColor = .black
                }
            case .denied:
                print("denied")
            case .restricted:
                print("restricted")
            @unknown default:
                print("어떤것이 추가 될 수 있음")
            }
        }
    }
    
    func configureCity() {
        mapBaseView.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CityCell.self, forCellWithReuseIdentifier: String(describing: CityCell.self))
        
    }
    
    
    // MARK: - Action
    @objc func detailBtnClicked(_ sender: UIButton) {
        print("상세조건 버튼이 눌렸음 - MapView ")
        detailFiveMarketCompletion?()
    }
    
    @objc func currentBtnClicked(_ sender: UIButton) {
        sender.isSelected.toggle()
        let isCurrent = sender.isSelected
        myLocationCompletion?(isCurrent)
        
    }
    
    // MARK: - setConstraints
    override func setConstraints() {
        
        mapBaseView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
           // make.edges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(110)
        }
        
        locationButtonBgView.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.trailing.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(15)
        }
        
        currentLocationButton.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
            
        }
        
        detailOpenFiveMarketButtonBgView.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.trailing.equalToSuperview().inset(15)
            make.bottom.equalTo(self.locationButtonBgView.snp.top).offset(-20)
        }
        
        detailOpenFiveMarketBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        locationButtonBgView.layer.cornerRadius = self.locationButtonBgView.frame.width / 2
        locationButtonBgView.layer.cornerCurve = .circular
        locationButtonBgView.clipsToBounds = true
        
        
        detailOpenFiveMarketButtonBgView.layer.cornerRadius = self.detailOpenFiveMarketButtonBgView.frame.width / 2
        detailOpenFiveMarketButtonBgView.layer.cornerCurve = .circular
        detailOpenFiveMarketButtonBgView.clipsToBounds = true
    }
    
}

extension MapView {

    
    func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let spacing: CGFloat = 5
        let width = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: (width - (spacing * 8)) / 7, height: 93)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        return layout
    }

}
