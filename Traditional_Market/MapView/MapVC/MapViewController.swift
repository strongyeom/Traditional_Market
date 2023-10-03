//
//  ViewController.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/26.
//

import UIKit
import CoreLocation
import MapKit

final class MapViewController: BaseViewController {
    
    private let mapView = MapView()
    private let marketAPIManager = MarketAPIManager.shared
    private let viewModel = TraditionalMarketViewModel()
    private let realmManager = RealmManager()
    
    private var locationManger = {
        var location = CLLocationManager()
        location.allowsBackgroundLocationUpdates = true
        location.pausesLocationUpdatesAutomatically = false
        return location
    }()
    
    private var startLocation: CLLocationCoordinate2D? {
        didSet {
            setMyRegion(center: startLocation ?? CLLocationCoordinate2D(latitude: 37.504721, longitude: 127.140886))
        }
    }
    
    // 권한 상태
    private var authorization: CLAuthorizationStatus = .notDetermined
    
    // stop or start 설정하는 토글
    private var isCurrentLocation: Bool = false
    
    // 내 위치 안에 있는 Annotation 담는 배열
    private var myRangeAnnotation: [MKAnnotation] = []
    
    // city
    private var selectedCity: String = "서울특별시"
    
    override func loadView() {
        self.view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func configureView() {
        setMapView()
        setLocation()
        setCollectionView()
        setNetwork()
        
    }
    
    
    
    
    /// 해당 지역에 들어왔을때 로컬 알림 메서드
    fileprivate  func registLocation() {
        print("범위에 속하는 어노테이션 갯수",myRangeAnnotation.count)
        print("myRangeAnnotation",myRangeAnnotation)
        // 내 범위에서 내 위치는 렌더링 하지 않기
        let myLocationRangeRemoveMyLocation = myRangeAnnotation.filter { $0.title!! != "My Location"}
        // 내 위치 반경에 해당하는 어노테이션만 가져오기
        for i in myLocationRangeRemoveMyLocation {
            print("iii",i)
            let regionCenter = CLLocationCoordinate2DMake(i.coordinate.latitude, i.coordinate.longitude)
            let exampleRegion = CLCircularRegion(center: i.coordinate, radius: 50.0, identifier: "\(i.title! ?? "내위치")")
            let circleRagne = MKCircle(center: regionCenter, radius: 50.0)
            mapView.mapBaseView.addOverlay(circleRagne)
            
            exampleRegion.notifyOnEntry = true
            exampleRegion.notifyOnExit = true
            locationManger.startMonitoring(for: exampleRegion)
        }
        // 🧐 UNLocationNotificationTrigger 고민해보기
    }
    
    // 내 위치 범위 산정
    fileprivate  func setMyRegion(center: CLLocationCoordinate2D) {
        myRangeAnnotation = []
        
        let range = 200.0
        let regionCenter = CLLocationCoordinate2DMake(center.latitude, center.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
        let regionRange = CLCircularRegion(center: center, radius: range, identifier: "내 위치")
        let circle = MKCircle(center: regionCenter, radius: range)
        mapView.mapBaseView.addOverlay(circle)
        // print("내 위치 반경 \(region)")
        mapView.mapBaseView.setRegion(region, animated: true)
        
        
        for i in mapView.mapBaseView.annotations {
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
    
    /// 어노테이션 추가
    fileprivate  func addAnnotation() {
        
        let items = marketAPIManager.marketList.response.body.items
        
        // Realm에 데이터 추가
        let _ = items.map {
            realmManager.addData(market: $0)
        }
        // CityCell 눌렀을때 해당 지역 Annotation만 보여주기
        filterCityAnnotation()
        
        print(mapView.mapBaseView.annotations.count)
    }
    
    
    /// 해당 지역 Annotation만 보여주기
    fileprivate  func filterCityAnnotation() {
        // LazyMapSequence<Results<TraditionalMarketRealm>, MKAnnotation>로 나온것을 배열로 만들어주기 위해 변수 설정
        var mkAnnotationConvert: [MKAnnotation] = []
        
        // mapView에 있는 어노테이션 삭제
        mapView.mapBaseView.removeAnnotations(mapView.mapBaseView.annotations)
        
        let realmAnnotation = realmManager.filterData(region: selectedCity).map {
            (realItem) -> MKAnnotation in
            let pin = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: Double(realItem.latitude!) ?? 0.0, longitude: Double(realItem.longitude!) ?? 0.0))
            pin.title = realItem.marketName
            return pin
        }
        
        // 반복문을 사용하여 배열 안에 담아주기
        for i in realmAnnotation {
            mkAnnotationConvert.append(i)
        }
        mapView.mapBaseView.addAnnotations(mkAnnotationConvert)
    }
    
    /// 권한 - 허용안함을 눌렀을때 Alert을 띄우고 iOS 설정 화면으로 이동
    fileprivate  func showLocationSettingAlert() {
        let alert = UIAlertController(title: "위치 정보 설정", message: "설정>개인 정보 보호> 위치 여기로 이동해서 위치 권한 설정해주세요", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "위치 설정하기", style: .default) { _ in
            // iOS 설정 페이지로 이동 : openSettingURLString
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(goSetting)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    /// 상태가 바뀔때 마다 권한 확인
    fileprivate func checkDeviceLocationAuthorization() {
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
    fileprivate func checkStatuesDeviceLocationAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("아무것도 결정하지 않았다.")
            // p.list 알람 띄우기
            locationManger.requestWhenInUseAuthorization()
        case .restricted:
            print("권한 설정 거부함")
            showLocationSettingAlert()
        case .denied:
            print("권한 설정 거부함")
            showLocationSettingAlert()
        case .authorizedAlways:
            print("항상 권한 허용")
            locationManger.startUpdatingLocation()
        case .authorizedWhenInUse:
            print("한번만 권한 허용")
            locationManger.startUpdatingLocation()
            addAnnotation()
            setMyRegion(center: startLocation ?? CLLocationCoordinate2D(latitude: 37.503685, longitude: 127.140901))
            mapView.currentLocationButton.isSelected = true
        case .authorized:
            print("권한 허용 됨")
        @unknown default:
            print("어떤것이 추가 될 수 있음")
        }
    }
    
    
    
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first?.coordinate {
            startLocation = location
            print("시작 위치를 받아오고 있습니다 \(location)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치를 받아오지 못했을때 - \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("위치 권한이 바뀔때 마다 호출 - ")
        checkDeviceLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard let region = region as? CLCircularRegion else { return }
        showAlert(title: "\(region.identifier)", message: "\(region.identifier) 해당 지역에 들어왔습니다.")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        guard let region = region as? CLCircularRegion else { return }
        showAlert(title: "\(region.identifier)", message: "\(region.identifier) 해당 지역에서 나갔습니다.")
    }
    
    
    // Geofencing Error 처리
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        guard let region = region else {
            print("지역을 모니터링할 수 없으며, 실패 원인을 알 수 없습니다.")
            return
        }
        print("식별자를 사용하여 지역을 모니터링하는 동안 오류가 발생했습니다: \(region.identifier)")
    }
    
    // rendering
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = .red
        circleRenderer.fillColor = UIColor.yellow.withAlphaComponent(0.3)
        circleRenderer.lineWidth = 1.0
        return circleRenderer
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    // MapView를 터치했을때 액션 메서드
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        locationManger.stopUpdatingLocation()
        mapView.currentLocationButton.isSelected = false
        mapView.currentLocationButton.tintColor = .black
    }
    
    // 어노테이션을 클릭했을때 액션 메서드
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        //  print("여기가 타는건가??",annotation.title!!)
        let detailVC = DetailViewController()
        // Realm 필터를 사용해서 Item 하나만 던져주기
        detailVC.selectedMarket = viewModel.selectedMarketInfomation(location: annotation.coordinate)
        detailVC.isLikeClickedEvent()
        self.dismiss(animated: true) {
            self.present(detailVC, animated: true)
        }
        
        
        
    }
    
    
    func mapView(_ mapView: MKMapView, didDeselect annotation: MKAnnotation) {
        dismiss(animated: true)
    }
}

extension MapViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("해당 인덱스 \(indexPath.item)")
        let cityIndex = CityIndex(rawValue: indexPath.item)
        guard let cityIndex else { return }
        print("didSelectItemAt",cityIndex.indexToCity)
        selectedCity = cityIndex.indexToCity
        filterCityAnnotation()
    }
}


extension MapViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mapView.cityList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CityCell.self), for: indexPath) as? CityCell else { return UICollectionViewCell() }
        let data = mapView.cityList[indexPath.item]
        cell.imageView.image = UIImage(named: data.imageName)
        return cell
    }
}


extension MapViewController {
    fileprivate func setNetwork() {
        // 전통시장 API에서 데이터 불러오기
        marketAPIManager.request { item in
            print("총 시장 갯수",item.response.body.items.count)
        }
    }
    
    fileprivate func setCollectionView() {
        mapView.collectionView.delegate = self
        mapView.collectionView.dataSource = self
    }
    
    fileprivate func setLocation() {
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest // 정확성
        checkDeviceLocationAuthorization()
        registLocation()
    }
    
    fileprivate func setMapView() {
        mapView.mapBaseView.delegate = self
        buttonEvent()
        mapView.mapBaseView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: String(describing: MKAnnotationView.self))
        
    }
    
    /// 버튼의 이벤트를 받아 start와 stop 할 수 있음
    fileprivate func buttonEvent() {
        mapView.completion = { isCurrent in
            
            self.isCurrentLocation = isCurrent
            print("isCurrentLocation",self.isCurrentLocation)
            
            if isCurrent {
                self.locationManger.startUpdatingLocation()
            } else {
                self.locationManger.stopUpdatingLocation()
            }
        }
    }
}
