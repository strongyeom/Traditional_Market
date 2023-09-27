//
//  ViewController.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/26.
//

import UIKit
import CoreLocation
import MapKit
import Toast

final class MapViewController: UIViewController {

    let mapView = MapView()
    
    var locationManger = {
       var location = CLLocationManager()
        location.allowsBackgroundLocationUpdates = true
        location.pausesLocationUpdatesAutomatically = false
       
        return location
    }()
    
    var trigger: UNLocationNotificationTrigger?
    var request: UNNotificationRequest?
    
    var startLocation: CLLocationCoordinate2D? {
        didSet {
            setMyRegion(center: startLocation ?? CLLocationCoordinate2D(latitude: 37.504721, longitude: 127.140886))
        }
    }
    
    var previousCoordinate: CLLocationCoordinate2D?
    
    // 권한 상태
    var authorization: CLAuthorizationStatus = .notDetermined

    // stop or start 설정하는 토글
    var isCurrentLocation: Bool = false
    
    // 내 위치 안에 있는 Annotation 담는 배열
    var myRangeAnnotation: [MKAnnotation] = []
    
    let page = 1
    
    var list: [Item] = []
    override func loadView() {
        self.view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.mapBaseView.delegate = self
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest // 정확성
        checkDeviceLocationAuthorization()
        registLocation()
        buttonEvent()
        
        
//        for page in pages {
//            NetworkManager.shared.request(page: page) { response in
//                dump(response)
//            }
//        }
//
        NetworkManager.shared.request(page: page) { response in
            dump(response)
            self.list = response
        }

//        NetworkManager.shared.requestExample(api: IntegrationAPI.traditional(pageNo: String(page), numberOfRow: "100", type: "json")) { response in
//            dump(response)
//        }
//
//

//        NetworkManager.shared.requstConvertible(api: .allMarket(pageNo: "1", numberOfRow: "100", type: "json")) { response in
//            dump(response)
//        }
        
    }
    
    /// 버튼의 이벤트를 받아 start와 stop 할 수 있음
    func buttonEvent() {
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

 
    /// 해당 지역에 들어왔을때 로컬 알림 메서드
    func registLocation() {
        
        print("범위에 속하는 어노테이션 갯수",myRangeAnnotation.count)
        // 내 위치 반경에 해당하는 어노테이션만 가져오기
        for i in myRangeAnnotation {
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
    func setMyRegion(center: CLLocationCoordinate2D) {
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
    func addAnnotation() {
        let aPin = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 37.504721, longitude: 127.140886))
        aPin.title = "거여초"
        let bPin = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 37.501638, longitude: 127.138247))
        bPin.title = "홍팥집"
        let cPin = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 37.502610, longitude: 127.140219))
        cPin.title = "우진약국"
        
        
        let aa = list.map { (item) -> MKAnnotation in
            let pin = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: Double(item.latitude)!, longitude: Double(item.longitude)!))
            pin.title = item.marketName
            return pin
        }

        
        
        
        mapView.mapBaseView.addAnnotations(aa)
        print(mapView.mapBaseView.annotations.count)
    }
    
    func myRegionFilterAnnotation() {
        
    }
 
    /// 권한 - 허용안함을 눌렀을때 Alert을 띄우고 iOS 설정 화면으로 이동
    func showLocationSettingAlert() {
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
           //  집: 37.503685, 127.140901
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        locationManger.stopUpdatingLocation()
        mapView.currentLocationButton.isSelected = false
        mapView.currentLocationButton.tintColor = .red
    }
}
