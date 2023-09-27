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

class ViewController: UIViewController {
    
    let mapView = MapView()
    
    var locationManger = {
       var location = CLLocationManager()
        location.allowsBackgroundLocationUpdates = true
        location.pausesLocationUpdatesAutomatically = false
       
        return location
    }()
    
    var trigger: UNLocationNotificationTrigger?
    var request: UNNotificationRequest?
    
    var startLocation: CLLocationCoordinate2D?
    
    var previousCoordinate: CLLocationCoordinate2D?
    
    // 권한 상태
    var authorization: CLAuthorizationStatus = .notDetermined

    // stop or start 설정하는 토글
    var isCurrentLocation: Bool = false
    
    // 내 위치 안에 있는 Annotation 담는 배열
    var myRangeAnnotation: [MKAnnotation] = []
    
    
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
        
        
        mapView.completion = { isCurrent in
            
            self.isCurrentLocation = isCurrent
            print("isCurrentLocation",self.isCurrentLocation)
           
            if isCurrent {
                self.locationManger.startUpdatingLocation()
                self.setRegion(center: self.startLocation ?? CLLocationCoordinate2D(latitude: 37.503685, longitude: 127.140901))
            } else {
                self.locationManger.stopUpdatingLocation()
            }
        }
    }
    

 
    /// 해당 지역에 들어왔을때 로컬 알림 메서드
    func registLocation() {
        print(mapView.mapBaseView.annotations.count)
        // 어차피 어노테이션이 찍히면 해당 어노테이션의 coordinate 값 생김
        print("범위에 속하는 어노테이션 갯수",myRangeAnnotation.count)
        for i in myRangeAnnotation {
           
            
            
                /*
                 let range = 200.0
                 let regionCenter = CLLocationCoordinate2DMake(center.latitude, center.longitude)
                 let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
                 let regionRange = CLCircularRegion(center: center, radius: range, identifier: "내 위치")
                 let circle = MKCircle(center: regionCenter, radius: range)
                 mapView.mapBaseView.addOverlay(circle)
                 */
            
            let regionCenter = CLLocationCoordinate2DMake(i.coordinate.latitude, i.coordinate.longitude)
            let exampleRegion = CLCircularRegion(center: i.coordinate, radius: 50.0, identifier: "\(i.coordinate.latitude) + \(i.coordinate.longitude)")
            let circleRagne = MKCircle(center: regionCenter, radius: 100.0)
            mapView.mapBaseView.addOverlay(circleRagne)
            
            exampleRegion.notifyOnEntry = true
            exampleRegion.notifyOnExit = true
            locationManger.startMonitoring(for: exampleRegion)
            print("region regist: \(exampleRegion)")
        }
        // 🧐 UNLocationNotificationTrigger 고민해보기
    }
    
    // 첫 로드시 내 위치 범위 산정
    func setRegion(center: CLLocationCoordinate2D) {
        myRangeAnnotation = []
        /*
         let 홍대입구역중앙 = CLLocationCoordinate2DMake(37.55769, 126.92450)
          let 범위 = 100.0 //100meter를 뜻함
          
          let 홍대입구역범위 = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 홍대입구역중앙.latitude,
                                                                       longitude: 홍대입구역중앙.longitude), radius: 범위, identifier: "홍대입구역")
          let 원모양 = MKCircle(center: 홍대입구역중앙, radius: 범위)
          mapView.addOverlay(원모양)
          
          ...
         */
        let range = 200.0
        let regionCenter = CLLocationCoordinate2DMake(center.latitude, center.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
        let regionRange = CLCircularRegion(center: center, radius: range, identifier: "내 위치")
        let circle = MKCircle(center: regionCenter, radius: range)
        mapView.mapBaseView.addOverlay(circle)
        print("내 위치 반경 \(region)")
        mapView.mapBaseView.setRegion(region, animated: true)
        
        for i in mapView.mapBaseView.annotations {
            if regionRange.contains(i.coordinate) {
                print("\(i.title ?? "")가 내 위치에 포함되어 있습니다.")
                // 범위안에 있는 것만 따로 배열에 담아서 registLocation타게 하기
                myRangeAnnotation.append(i)
            } else {
                print("\(i.title ?? "")가 내 위치에 포함되어 있지 않습니다.")
            }
        }
        registLocation()
    }
    
    // 집: 37.503685, 127.140901
    
    // 37.504721, 127.140886 거여초
    // 37.501638, 127.138247 홍팥집
    // 37.502610, 127.140219 우진약구
    /// 어노테이션 추가
    func addAnnotation() {
        let aPin = CustomAnnotation(title: "거여초", coordinate: CLLocationCoordinate2D(latitude: 37.504721, longitude: 127.140886))
        let bPin = CustomAnnotation(title: "홍팥집", coordinate: CLLocationCoordinate2D(latitude: 37.501638, longitude: 127.138247))
        let cPin = CustomAnnotation(title: "우진약국", coordinate: CLLocationCoordinate2D(latitude: 37.502610, longitude: 127.140219))
        

        
        mapView.mapBaseView.addAnnotations([aPin, bPin, cPin])
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
            // registLocation()
            setRegion(center: startLocation ?? CLLocationCoordinate2D(latitude: 37.503685, longitude: 127.140901))
            mapView.currentLocationButton.isSelected = true
        case .authorized:
            print("권한 허용 됨")
        @unknown default:
            print("어떤것이 추가 될 수 있음")
        }
    }
    
    
    
}

extension ViewController: CLLocationManagerDelegate {
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

extension ViewController: MKMapViewDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        locationManger.stopUpdatingLocation()
        mapView.currentLocationButton.isSelected = false
        mapView.currentLocationButton.tintColor = .red
    }
}
