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
        return location
    }()
    
    var trigger: UNLocationNotificationTrigger?
    var request: UNNotificationRequest?
    
    // 권한 상태
    var authorization: CLAuthorizationStatus = .notDetermined

    override func loadView() {
        self.view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.mapBaseView.delegate = self
        locationManger.delegate = self
        checkDeviceLocationAuthorization()
        registLocation()
    }
    

 
    /// 해당 지역에 들어왔을때 로컬 알림 메서드
    func registLocation() {

        let 청취사 = CLLocationCoordinate2D(latitude: 37.517742, longitude: 126.886463)
        let 문래역 = CLLocationCoordinate2D(latitude: 37.518594, longitude: 126.894798)
        let 문래편의점 = CLLocationCoordinate2D(latitude: 37.517412, longitude: 126.889103)
         // 37.518594 - 37.517412
        let region = CLCircularRegion(center: 청취사, radius: 1.0, identifier: "청취사")
        region.notifyOnEntry = true
        region.notifyOnExit = true
        
        let region1 = CLCircularRegion(center: 문래역, radius: 1.0, identifier: "문래역")
        region1.notifyOnEntry = true
        region1.notifyOnExit = true
        
        let region2 = CLCircularRegion(center: 문래편의점, radius: 1.0, identifier: "문래편의점")
        region2.notifyOnEntry = true
        region2.notifyOnExit = true
        
        
        locationManger.allowsBackgroundLocationUpdates = true
        locationManger.pausesLocationUpdatesAutomatically = false
        
        locationManger.startMonitoring(for: region)
        locationManger.startMonitoring(for: region1)
        locationManger.startMonitoring(for: region2)
       
        // 🧐 UNLocationNotificationTrigger 고민해보기
        print("region regist: \(region)")
    }
    
    
    func addAnnotation() {
        let aPin = CustomAnnotation(title: "청취사", coordinate: CLLocationCoordinate2D(latitude: 37.517742, longitude: 126.886463))
        let bPin = CustomAnnotation(title: "문래역", coordinate: CLLocationCoordinate2D(latitude: 37.518594, longitude: 126.894798))
        let cPin = CustomAnnotation(title: "문래편의점", coordinate: CLLocationCoordinate2D(latitude: 37.517412, longitude: 126.889103))
        
        mapView.mapBaseView.addAnnotations([aPin, bPin, cPin])
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
             registLocation()
        case .authorized:
            print("권한 허용 됨")
        @unknown default:
            print("어떤것이 추가 될 수 있음")
        }
    }
    
    
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mapView.mapBaseView.userTrackingMode = .followWithHeading
        addAnnotation()
       // print("위치를 성공적으로 받아왔을때 - \(locations)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치를 받아오지 못했을때 - \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("위치 권한이 바뀔때 마다 호출 - ")
        checkDeviceLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
       // print("여기의 위, 경도는 어떻게 될까? \(region)")
//
//        switch state {
//        case .inside:
//            print(" \(region.identifier) 들어왔습니다.")
//            // 이때 노티를 띄어주면 되지 않을까?
//
//            // 노티가 안되기때문에 토스트 해줬는데... 노티 띄어주고 싶다 ㅠㅠ
//            self.view.makeToast("여기는 \(region.identifier) 입니다", duration: 10.0, position: .bottom) { didTap in
//                if didTap {
//                    print("토스트가 터치되었습니다.")
//                } else {
//                    print("completion without tap")
//                }
//            }
//        case .outside:
//            print("\(region.identifier)을 나왔습니다.")
//        case .unknown:
//            break
//        }
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
    
}

extension ViewController: MKMapViewDelegate {
    
}


/*
 class ViewController: UIViewController {
    
     private func setupGeofencing() {
         guard CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) else {
             showAlert(message: "Geofencing is not supported on this device")
             return
         }
         
         guard locationManager?.authorizationStatus == .authorizedAlways else {
             showAlert(message: "App does not have correct location authorization")
             return
         }
         
         startMonitoring()
     }

     private func startMonitoring() {
         let regionCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.3346438, longitude: -122.008972)
         let geofenceRegion: CLCircularRegion = CLCircularRegion(
             center: regionCoordinate,
             radius: 100, // Radius in Meter
             identifier: "apple_park" // unique identifier
         )
         
         
         geofenceRegion.notifyOnEntry = true
         geofenceRegion.notifyOnExit = true
         
         // Start monitoring
         locationManager?.startMonitoring(for: geofenceRegion)
     }
     
     private func showAlert(message: String) {
         let alertController = UIAlertController(title: "Information", message: message, preferredStyle: .alert)
         alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
         self.present(alertController, animated: true, completion: nil)
     }
 }
 

 */
